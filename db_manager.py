import json
import os
import time
fname="pipeline.json"
db_fname="affirmation_db.json"
update_interval=1

def clear_pipe():
    with open(fname,"w") as f:
        f.write("")

def get_db():
    with open(db_fname,"r") as f:
        return json.load(f)
    
def verify_id(db:list,id:str):
    for entry in db:
        if entry["id"]==id:
            return False    
    return True

def write_success_status(status:bool,errors=None):
    """Write null if no duplicated found,Otherwise list"""
    result={"success":status,"errors":errors}
    with open(fname,"w") as f:
        json.dump(result,f)
        
def save_to_db(data:list):
    with open(db_fname,"w") as f:
        json.dump(data,f)
        
def main():
    not_printed=True
    while os.path.getsize(fname)==0:
        if not_printed:
            print("Waiting for Input...")
            not_printed=False
        time.sleep(update_interval) 
    try:
        with open(fname,"r") as f:
            data=json.load(f)
            if "success" in data:
                return
        clear_pipe()
    except Exception as e:
        print(f"Error occured while parsing json: {e}")
        return None
    db_data=get_db()
    errors=[]
    success=False
    if isinstance(data,list):
        for entry in data:
            try:
                if verify_id(db_data,entry["id"]):
                    db_data.append(entry)
                    success=True
                else: 
                    print(f"Entry ID: {entry["id"]} exist in database")
                    entry["error"]="id exist in database"
                    errors.append(entry)
            except Exception as e:
                entry["error"]="Unknown error occured"
                errors.append(entry)
    elif isinstance(data,dict):
        try:
            if verify_id(db_data,data["id"]):
                db_data.append(data)
                success=True
            else: 
                print(f"Entry ID: {data["id"]} exist in database")
                data["error":"id exist in database"]
                errors.append(data)
                success=False
        except Exception as e:
            data["error"]="id does not exist"
            errors.append(data)
            success=False
    else:
        print("Unrecognized Data format")
        success=False
    write_success_status(success,errors if len(errors)>0 else None)
    save_to_db(db_data)

if __name__=="__main__":
    while True:
        main()
        time.sleep(1)
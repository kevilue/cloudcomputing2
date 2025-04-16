# Python script for creating collections in the jokes database
# Takes the name of the collection as input arguments and creates
# it inside the database "jokes"
import argparse
import pymongo

# Add arguments for command line input
parser = argparse.ArgumentParser(description="Create a collection in the jokes database")
parser.add_argument("-collection", type=str, help="Name of the collection to create")
parser.add_argument("-connection_string", type=str, help="MongoDB connection string")
parser.add_argument("-timeout", type=str, help="MongoDB connection timeout in ms. Default is 5000.", default="5000")

# Parse the arguments
args = parser.parse_args()

# Connect to MongoDB client
try:
    client = pymongo.MongoClient(args.connection_string, serverSelectionTimeoutMS=args.timeout)
    client.server_info()
except Exception as e:
    print(f"No connection to MongoDB client {args.connection_string} could be established: {e}")
    exit()

# Check if database exists
database_list = client.list_database_names()
if "jokes" not in database_list:
    # Ask user if they want to create the database
    create_db_input = input("No database called 'jokes' found. Create new one? (yes/no)\n")
    if create_db_input.lower() == "no":
        print("Aborting...")
        exit()

# Select or create database        
db = client["jokes"]
# Try selecting or creating the collection
try:
    collection = db[args.collection]
except Exception as e:
    print(f"Error creating collection {args.collection}: {e}")
    exit()

print(f"Collection '{args.collection}' created successfully in the 'jokes' database.")
# Close the connection
client.close()
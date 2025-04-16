# Python script to check the given MongoDB connection and
# ask the user if they want to create a database "jokes" for the webapp.
# Abort if the user does not want to create the database.
import argparse
import pymongo

# Add arguments for command line input
parser = argparse.ArgumentParser(description="Create a collection in the jokes database")
parser.add_argument("-collection", type=str, help="Name of the collection to create")
parser.add_argument("-connection_string", type=str, help="MongoDB connection string")
parser.add_argument("-timeout", type=str, help="MongoDB connection timeout in ms. Default is 5000.", default="5000")

# Parse the arguments
args = parser.parse_args()

# Check if the MongoDB connection exists
try:
    client = pymongo.MongoClient(args.connection_string, serverSelectionTimeoutMS=args.timeout)
    # Force client to connect to the server
    client.server_info()
except Exception as e:
    print(f"No connection to MongoDB client {args.connection_string} could be established: {e}")
    exit()

# Check if database exists
database_list = client.list_database_names()
if "jokes" not in database_list:
    # Ask user if they want to create the database when adding jokes
    create_db_input = input(f"No database called 'jokes' found. A new one will be created when adding jokes over the webapp.\nJokes and comments will be stored in collection '{args.collection}'. Proceed? (yes/no) ")
    if create_db_input.lower() == "no":
        print("Aborting...")
        exit()

# Inform user
print(f"Jokes will be stored in database 'jokes' and collection '{args.collection}'.")
# Close the connection
client.close()
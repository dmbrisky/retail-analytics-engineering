



# Import Python's built-in JSON library.
# We use this to write the API response to a JSON file.
import json
import os

# Import the requests library.
# This allows Python to make HTTP requests to REST APIs.
import requests
import snowflake.connector
from dotenv import load_dotenv

load_dotenv()
conn = snowflake.connector.connect(
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    user=os.getenv("SNOWFLAKE_USER"),
    password=os.getenv("SNOWFLAKE_PASSWORD"),
    warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
    database=os.getenv("SNOWFLAKE_DATABASE"),
    schema=os.getenv("SNOWFLAKE_SCHEMA")
)

print("Connected to Snowflake successfully.")

cursor = conn.cursor()

 # Insert that API response into RAW.IBGE in Snowflake.
cursor.execute("""
CREATE TABLE IF NOT EXISTS STATES_RAW (
    load_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    payload VARIANT
)
""")

print("Snowflake raw table is ready.")



cursor.execute("TRUNCATE TABLE STATES_RAW")

print("Existing Snowflake state records cleared.")


# Store the API endpoint in a variable.
# This IBGE endpoint returns a list of all Brazilian states.
# At this point, we have NOT called the API yet.
url = "https://servicodados.ibge.gov.br/api/v1/localidades/estados"


# Send an HTTP GET request to the API endpoint.
# The API's response is stored in the variable "response".
response = requests.get(url)


# Print the HTTP status code so we can see whether the request succeeded.
# 200 = successful request.
print(response.status_code)


# Check the response for an HTTP error.
# If the API returned something like 404 or 500,
# Python will raise an error instead of continuing with bad data.
response.raise_for_status()


# Convert the JSON returned by the API into Python objects.
# In this case, the JSON array becomes a Python list of dictionaries.
data = response.json()


# Inspect the response while developing/testing the ingestion.
# type(data) should show "list".
print(type(data))

# Show how many state records the API returned.
# We expect 27.
print(len(data))

# Show the first state record so we can inspect its structure and fields.
print(data[0])


# Create a local raw JSON file and write the complete API response to it.
# "w" means write/create the file.
# UTF-8 allows Brazilian characters such as ô and ã to be stored correctly.
with open("ibge_states_raw.json", "w", encoding="utf-8") as file:

    # Write our Python data back into JSON format.
    # indent=4 makes the file human-readable.
    # ensure_ascii=False preserves accented characters instead of escaping them.
    json.dump(data, file, indent=4, ensure_ascii=False)


# Print a confirmation after the JSON file has been successfully written.
print("Raw IBGE data saved successfully.")

# Load each state record into the Snowflake raw table.
for state in data:
    cursor.execute(
        "INSERT INTO STATES_RAW (payload) SELECT PARSE_JSON(%s)",
        (json.dumps(state),)
    )

print(f"Loaded {len(data)} state records into Snowflake.")
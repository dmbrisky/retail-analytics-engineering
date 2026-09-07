import requests
import json

url = "https://jsonplaceholder.typicode.com/todos"

page = 1

all_data = []

while True:

    print(f"Requesting page {page}")

    params = {
        "_page": page,
        "_limit": 5
    }

    try:
        response = requests.get(url, params=params)

        print(response.status_code)
        response.raise_for_status()

        data = response.json()

        all_data.extend(data)

        if len(data) == 0:
            break

        print(len(data))
        print(data[0])

        page = page + 1

    except requests.exceptions.RequestException as error:
        print(f"API request failed: {error}")
        break

with open("todos_raw.json", "w") as file:
    json.dump(all_data, file, indent=4)

# Print the total number of records collected.
print(f"Total records: {len(all_data)}")

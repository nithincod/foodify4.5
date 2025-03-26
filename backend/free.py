from openai import OpenAI
import json

# Set up API key and base URL
API_KEY = "ddc-SAA8lYnjR4kGJgxqz5knv4jrWrvtvdHpD3efArlFZVwGEF6kkG"
BASE_URL = "https://api.sree.shop/v1"

client = OpenAI(
    api_key=API_KEY,
    base_url=BASE_URL
)

print("--- Listing All Models ---\n")

try:
    models = client.models.list().data
    for model in models:
        print(model.id)
except Exception as e:
    print("Error listing models:", e)


print("\n--- Chat Completions ---\n")
print("Model: gpt-4o\n")
try:
    completion = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "user", "content": "Hello, how are you?"}
        ]
    )
    print(completion.choices[0].message)
except Exception as e:
    print("Error creating chat completion:", e)


print("Model: claude-3-5-sonnet-20240620\n")
try:
    completion = client.chat.completions.create(
        model="claude-3-5-sonnet-20240620",
        messages=[
            {"role": "user", "content": "Hello, how are you?"}
        ]
    )
    print(completion.choices[0].message)
except Exception as e:
    print("Error creating chat completion:", e)


print("Model: deepseek-ai/DeepSeek-R1-Distill-Qwen-32B\n")
try:
    completion = client.chat.completions.create(
        model="deepseek-ai/DeepSeek-R1-Distill-Qwen-32B",
        messages=[
            {"role": "user", "content": "Hello, how are you?"}
        ]
    )
    print(completion.choices[0].message)
except Exception as e:
    print("Error creating chat completion:", e)


print("Model: deepseek-r1\n")
try:
    completion = client.chat.completions.create(
        model="deepseek-r1",
        messages=[
            {"role": "user", "content": "Hello, how are you?"}
        ]
    )
    print(completion.choices[0].message)
except Exception as e:
    print("Error creating chat completion:", e)


print("Model: deepseek-v3\n")
try:
    completion = client.chat.completions.create(
        model="deepseek-v3",
        messages=[
            {"role": "user", "content": "Hello, how are you?"}
        ]
    )
    print(completion.choices[0].message)
except Exception as e:
    print("Error creating chat completion:", e)


print("Model: Meta-Llama-3.3-70B-Instruct-Turbo\n")
try:
    completion = client.chat.completions.create(
        model="Meta-Llama-3.3-70B-Instruct-Turbo",
        messages=[
            {"role": "user", "content": "Hello, how are you?"}
        ]
    )
    print(completion.choices[0].message)
except Exception as e:
    print("Error creating chat completion:", e)

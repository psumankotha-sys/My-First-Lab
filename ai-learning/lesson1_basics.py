# AI apps work with these data types constantly!

# Strings — LLM prompts and responses
user_prompt = "Check my Kubernetes cluster health"
system_prompt = "You are a DevOps AI assistant"
llm_response = "Your cluster has 3 healthy nodes"

# Numbers — tokens, costs, temperatures
temperature = 0.7        # How creative the AI is (0-1)
max_tokens = 1000        # Max response length
token_count = 150        # Tokens used
cost_per_token = 0.00001 # Cost calculation

# Boolean — AI decision making
is_healthy = True
needs_action = False
auto_fix = True

# Lists — multiple messages, multiple agents
messages = [
    "Pod suman-app is running",
    "Pod grafana is running",
    "Pod prometheus is failing!"
]

agent_names = ["monitor", "diagnose", "fix", "report"]

# Dictionary — API request/response format
api_request = {
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 1000,
    "messages": [
        {
            "role": "user",
            "content": "Check my K8s cluster"
        }
    ]
}

# Print and understand
print("=== AI Data Types ===")
print(f"Prompt: {user_prompt}")
print(f"Temperature: {temperature}")
print(f"Auto fix: {auto_fix}")
print(f"Agents: {agent_names}")
print(f"Messages count: {len(messages)}")
print(f"API model: {api_request['model']}")

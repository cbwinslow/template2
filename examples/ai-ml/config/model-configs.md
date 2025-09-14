# AI/ML Model Configuration Examples

## Language Model Configurations

### OpenAI GPT Configuration
```yaml
openai:
  model: "gpt-4"
  temperature: 0.7
  max_tokens: 2000
  top_p: 1.0
  frequency_penalty: 0.0
  presence_penalty: 0.0
  
  # Prompt templates
  code_review_prompt: |
    Please review the following code for:
    - Code quality and best practices
    - Security vulnerabilities
    - Performance optimizations
    - Testing recommendations
    
    Code: {code}
    
  documentation_prompt: |
    Generate comprehensive documentation for this code:
    {code}
    
    Include:
    - Purpose and functionality
    - Parameters and return values
    - Usage examples
    - Error handling
```

### Anthropic Claude Configuration
```yaml
anthropic:
  model: "claude-3-sonnet-20240229"
  max_tokens: 4000
  temperature: 0.3
  
  system_prompt: |
    You are an expert software developer and code reviewer.
    Focus on providing actionable, specific feedback that improves
    code quality, security, and maintainability.
```

### Local Model Configuration (Ollama)
```yaml
ollama:
  model: "codellama:13b"
  base_url: "http://localhost:11434"
  
  # Code generation settings
  code_generation:
    temperature: 0.1
    num_predict: 500
    top_k: 10
    top_p: 0.9
```

## Model Training Configurations

### Python ML Pipeline
```python
# examples/ai-ml/config/training_config.py
from dataclasses import dataclass
from typing import Dict, Any

@dataclass
class ModelConfig:
    model_type: str = "transformer"
    model_size: str = "base"
    learning_rate: float = 1e-4
    batch_size: int = 32
    max_epochs: int = 100
    early_stopping_patience: int = 10
    
    # Data configuration
    train_split: float = 0.8
    val_split: float = 0.1
    test_split: float = 0.1
    
    # Training settings
    gradient_accumulation_steps: int = 1
    warmup_steps: int = 1000
    weight_decay: float = 0.01
    
    def to_dict(self) -> Dict[str, Any]:
        return self.__dict__
```

This configuration provides a comprehensive foundation for AI/ML workflows, model management, and experimentation tracking within the Template2 repository.
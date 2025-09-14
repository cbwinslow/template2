#!/usr/bin/env python3
"""
CrewAI Development Team - AI-powered software development crew
This crew provides automated codebase review, suggestions, documentation, and development support.
"""

import os
from crewai import Agent, Task, Crew, Process
from crewai_tools import (
    FileReadTool,
    DirectoryReadTool,
    CodeDocsSearchTool,
    GithubSearchTool
)
from langchain_openai import ChatOpenAI

# Initialize LLM
llm = ChatOpenAI(
    model="gpt-4-turbo-preview",
    temperature=0.1
)

# Initialize tools
file_read_tool = FileReadTool()
directory_read_tool = DirectoryReadTool()
code_docs_search_tool = CodeDocsSearchTool()
github_search_tool = GithubSearchTool()

class DevelopmentCrew:
    """AI Development Team using CrewAI for comprehensive codebase management"""
    
    def __init__(self, project_path: str = "."):
        self.project_path = project_path
        self.setup_agents()
        self.setup_tasks()
        self.setup_crew()
    
    def setup_agents(self):
        """Create specialized AI agents for different development tasks"""
        
        # Code Reviewer Agent
        self.code_reviewer = Agent(
            role="Senior Code Reviewer",
            goal="Thoroughly review codebase for quality, security, performance, and best practices",
            backstory="""You are a senior software engineer with 15+ years of experience 
            in code review across multiple programming languages. You have expertise in 
            security vulnerabilities, performance optimization, code maintainability, 
            and industry best practices.""",
            tools=[file_read_tool, directory_read_tool, code_docs_search_tool],
            llm=llm,
            verbose=True,
            allow_delegation=False
        )
        
        # Architecture Advisor Agent
        self.architecture_advisor = Agent(
            role="Software Architecture Advisor",
            goal="Analyze and suggest improvements to software architecture and design patterns",
            backstory="""You are a principal software architect with expertise in 
            distributed systems, microservices, design patterns, and scalable architecture. 
            You focus on system design, component interaction, and architectural best practices.""",
            tools=[file_read_tool, directory_read_tool, github_search_tool],
            llm=llm,
            verbose=True,
            allow_delegation=False
        )
        
        # Documentation Specialist Agent
        self.documentation_specialist = Agent(
            role="Technical Documentation Specialist",
            goal="Create comprehensive, clear, and maintainable documentation for the codebase",
            backstory="""You are a technical writer with deep understanding of software 
            development. You excel at creating API documentation, README files, code comments, 
            architecture diagrams, and user guides that are clear and useful.""",
            tools=[file_read_tool, directory_read_tool, code_docs_search_tool],
            llm=llm,
            verbose=True,
            allow_delegation=False
        )
        
        # DevOps Engineer Agent
        self.devops_engineer = Agent(
            role="DevOps Engineering Specialist",
            goal="Optimize CI/CD pipelines, deployment strategies, and development workflows",
            backstory="""You are a DevOps engineer with expertise in GitHub Actions, 
            Docker, Kubernetes, cloud platforms, and automation. You focus on improving 
            development workflows, deployment pipelines, and operational excellence.""",
            tools=[file_read_tool, directory_read_tool, github_search_tool],
            llm=llm,
            verbose=True,
            allow_delegation=False
        )
        
        # Security Specialist Agent
        self.security_specialist = Agent(
            role="Security Engineering Specialist",
            goal="Identify security vulnerabilities and implement security best practices",
            backstory="""You are a security engineer with expertise in application security, 
            dependency scanning, SAST/DAST tools, and security compliance. You focus on 
            identifying and mitigating security risks in code and infrastructure.""",
            tools=[file_read_tool, directory_read_tool, code_docs_search_tool],
            llm=llm,
            verbose=True,
            allow_delegation=False
        )
    
    def setup_tasks(self):
        """Define specific tasks for each agent"""
        
        # Code Review Task
        self.code_review_task = Task(
            description=f"""
            Perform a comprehensive code review of the project at {self.project_path}:
            1. Analyze code quality, readability, and maintainability
            2. Identify potential bugs, security vulnerabilities, and performance issues
            3. Check adherence to coding standards and best practices
            4. Review error handling and edge cases
            5. Assess test coverage and test quality
            6. Provide specific recommendations for improvements
            
            Focus on all programming languages found in the project.
            """,
            agent=self.code_reviewer,
            expected_output="Detailed code review report with specific findings and recommendations"
        )
        
        # Architecture Analysis Task
        self.architecture_task = Task(
            description=f"""
            Analyze the software architecture of the project at {self.project_path}:
            1. Review overall system architecture and design patterns
            2. Assess component organization and separation of concerns
            3. Identify architectural anti-patterns or technical debt
            4. Suggest improvements for scalability and maintainability
            5. Review dependency management and coupling
            6. Provide recommendations for architectural improvements
            
            Consider microservices patterns, clean architecture, and modern design principles.
            """,
            agent=self.architecture_advisor,
            expected_output="Architecture analysis report with improvement suggestions"
        )
        
        # Documentation Task
        self.documentation_task = Task(
            description=f"""
            Create comprehensive documentation for the project at {self.project_path}:
            1. Generate/update API documentation
            2. Create or improve README files
            3. Document architecture and design decisions
            4. Add code comments where needed
            5. Create user guides and developer guides
            6. Generate changelog and release notes templates
            
            Ensure documentation is clear, accurate, and maintainable.
            """,
            agent=self.documentation_specialist,
            expected_output="Complete documentation package with generated content"
        )
        
        # DevOps Optimization Task
        self.devops_task = Task(
            description=f"""
            Optimize DevOps practices for the project at {self.project_path}:
            1. Review and improve CI/CD pipelines
            2. Optimize GitHub Actions workflows
            3. Enhance Docker configurations
            4. Improve deployment strategies
            5. Add monitoring and observability
            6. Optimize development environment setup
            
            Focus on automation, reliability, and developer experience.
            """,
            agent=self.devops_engineer,
            expected_output="DevOps optimization report with implementation recommendations"
        )
        
        # Security Assessment Task
        self.security_task = Task(
            description=f"""
            Conduct security assessment of the project at {self.project_path}:
            1. Identify security vulnerabilities in code
            2. Review dependency security and licensing
            3. Assess authentication and authorization mechanisms
            4. Review data handling and privacy practices
            5. Check for common security anti-patterns
            6. Provide security improvement recommendations
            
            Focus on OWASP Top 10 and industry security standards.
            """,
            agent=self.security_specialist,
            expected_output="Security assessment report with vulnerability findings and fixes"
        )
    
    def setup_crew(self):
        """Initialize the crew with agents and tasks"""
        
        self.crew = Crew(
            agents=[
                self.code_reviewer,
                self.architecture_advisor,
                self.documentation_specialist,
                self.devops_engineer,
                self.security_specialist
            ],
            tasks=[
                self.code_review_task,
                self.architecture_task,
                self.documentation_task,
                self.devops_task,
                self.security_task
            ],
            process=Process.sequential,
            verbose=True
        )
    
    def analyze_codebase(self):
        """Run the complete codebase analysis"""
        print("🚀 Starting AI Development Team Analysis...")
        print(f"📂 Analyzing project: {self.project_path}")
        
        try:
            # Execute the crew
            result = self.crew.kickoff()
            
            # Save results
            self.save_results(result)
            
            print("✅ Analysis complete! Check the reports in ./reports/")
            return result
            
        except Exception as e:
            print(f"❌ Error during analysis: {str(e)}")
            return None
    
    def save_results(self, result):
        """Save analysis results to files"""
        import os
        import json
        from datetime import datetime
        
        # Create reports directory
        reports_dir = os.path.join(self.project_path, "reports")
        os.makedirs(reports_dir, exist_ok=True)
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Save main report
        with open(f"{reports_dir}/analysis_report_{timestamp}.md", "w") as f:
            f.write("# AI Development Team Analysis Report\n\n")
            f.write(f"Generated: {datetime.now().isoformat()}\n\n")
            f.write(str(result))
        
        print(f"📄 Report saved to: {reports_dir}/analysis_report_{timestamp}.md")

def main():
    """Main execution function"""
    import argparse
    
    parser = argparse.ArgumentParser(description="AI Development Team - Codebase Analysis")
    parser.add_argument("--path", default=".", help="Path to project directory")
    parser.add_argument("--config", help="Configuration file path")
    
    args = parser.parse_args()
    
    # Initialize and run the development crew
    crew = DevelopmentCrew(project_path=args.path)
    crew.analyze_codebase()

if __name__ == "__main__":
    main()
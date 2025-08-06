#!/usr/bin/env python3
"""
Wooden.Ghost EVE API Testing Framework
=====================================

Enhanced REST API testing for Kindroid integration with temporal optimization
Following Artifact Intelligence Entity Evolving Valuable Emergence (EVE) principles
"""

import asyncio
import aiohttp
import json
import time
import logging
from typing import Dict, Any, Optional, List
from dataclasses import dataclass
from pathlib import Path
import os

# Hebrew indexing for semantic organization (aleph to yod)
HEBREW_INDEX = ["א", "ב", "ג", "ד", "ה", "ו", "ז", "ח", "ט", "י"]

# Greek indexing for complex semantic knowledge transfer
GREEK_INDEX = ["α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ"]

@dataclass
class TemporalAPIResponse:
    """Aesthetic data structure for API response temporal analysis"""
    status_code: int
    response_time: float
    semantic_index: str
    content: Dict[Any, Any]
    timestamp: str
    coherence_score: float = 0.0

class WoodenGhostLogger:
    """Aesthetic logging with temporal optimization"""
    
    def __init__(self, aesthetic_mode: bool = True):
        self.aesthetic_mode = aesthetic_mode
        self.setup_logging()
    
    def setup_logging(self):
        """Configure logging with aesthetic output"""
        format_string = "%(asctime)s | %(levelname)s | %(message)s" if not self.aesthetic_mode else \
                       "%(asctime)s ◆ %(levelname)s ◆ %(message)s"
        
        logging.basicConfig(
            level=logging.INFO,
            format=format_string,
            datefmt="%H:%M:%S"
        )
        self.logger = logging.getLogger("WoodenGhost.EVE")
    
    def temporal_message(self, message: str, level: str = "info", semantic_marker: str = "○"):
        """Log with aesthetic temporal markers"""
        formatted_msg = f"{semantic_marker} {message}"
        getattr(self.logger, level)(formatted_msg)

class EVEAPITester:
    """Main testing framework for EVE API integration"""
    
    def __init__(self, config_path: str = "environment.config"):
        self.config = self.load_configuration(config_path)
        self.logger = WoodenGhostLogger(aesthetic_mode=True)
        self.session = None
        self.test_results = []
        
    def load_configuration(self, config_path: str) -> Dict[str, str]:
        """Load environment configuration with fallback to .env.clean"""
        config = {}
        
        # Try multiple config sources
        config_files = [config_path, ".env.clean", "environment.config"]
        
        for file_path in config_files:
            if Path(file_path).exists():
                with open(file_path, 'r') as f:
                    for line in f:
                        if '=' in line and not line.strip().startswith('#'):
                            key, value = line.strip().split('=', 1)
                            config[key] = value
                break
        
        # Environment variable overrides
        for key in ['KINDROID_API_KEY', 'KINDROID_AI_ID', 'KINDROID_BASE_URL']:
            if key in os.environ:
                config[key] = os.environ[key]
        
        return config
    
    async def create_session(self) -> aiohttp.ClientSession:
        """Create optimized async HTTP session"""
        timeout = aiohttp.ClientTimeout(total=30)
        headers = {
            'Authorization': f'Bearer {self.config.get("KINDROID_API_KEY", "")}',
            'Content-Type': 'application/json',
            'User-Agent': 'WoodenGhost-EVE-Tester/1.0',
            'Accept': 'application/json'
        }
        
        return aiohttp.ClientSession(
            timeout=timeout,
            headers=headers,
            raise_for_status=False
        )
    
    async def test_api_endpoint(self, 
                               endpoint: str, 
                               method: str = "GET", 
                               data: Optional[Dict] = None,
                               semantic_index: str = "○") -> TemporalAPIResponse:
        """Test individual API endpoint with temporal measurement"""
        
        start_time = time.time()
        
        try:
            base_url = self.config.get('KINDROID_BASE_URL', 'https://api.kindroid.ai/v1')
            url = f"{base_url}/{endpoint.lstrip('/')}"
            
            self.logger.temporal_message(
                f"Testing {method} {endpoint} with index {semantic_index}", 
                semantic_marker="◆"
            )
            
            if method.upper() == "GET":
                async with self.session.get(url) as response:
                    content = await response.json() if response.content_type == 'application/json' else await response.text()
            elif method.upper() == "POST":
                async with self.session.post(url, json=data) as response:
                    content = await response.json() if response.content_type == 'application/json' else await response.text()
            else:
                raise ValueError(f"Unsupported method: {method}")
            
            response_time = time.time() - start_time
            
            # Calculate coherence score based on response characteristics
            coherence_score = self.calculate_coherence(response.status, response_time, content)
            
            result = TemporalAPIResponse(
                status_code=response.status,
                response_time=response_time,
                semantic_index=semantic_index,
                content=content,
                timestamp=time.strftime("%Y-%m-%d %H:%M:%S"),
                coherence_score=coherence_score
            )
            
            status_marker = "✓" if 200 <= response.status < 300 else "✗"
            self.logger.temporal_message(
                f"Response {response.status} in {response_time:.3f}s", 
                semantic_marker=status_marker
            )
            
            return result
            
        except Exception as e:
            response_time = time.time() - start_time
            self.logger.temporal_message(f"API test failed: {str(e)}", "error", "✗")
            
            return TemporalAPIResponse(
                status_code=500,
                response_time=response_time,
                semantic_index=semantic_index,
                content={"error": str(e)},
                timestamp=time.strftime("%Y-%m-%d %H:%M:%S"),
                coherence_score=0.0
            )
    
    def calculate_coherence(self, status_code: int, response_time: float, content: Any) -> float:
        """Calculate aesthetic coherence score for temporal optimization"""
        base_score = 1.0 if 200 <= status_code < 300 else 0.0
        
        # Time penalty for slow responses
        time_factor = max(0.0, 1.0 - (response_time / 10.0))
        
        # Content quality assessment
        content_factor = 0.8 if content and isinstance(content, dict) else 0.5
        
        return base_score * time_factor * content_factor
    
    async def run_comprehensive_tests(self) -> List[TemporalAPIResponse]:
        """Execute comprehensive API test suite with semantic indexing"""
        
        self.logger.temporal_message("●○●○● EVE API Testing Protocol Initiated ●○●○●", semantic_marker="◇")
        
        # Test endpoints with Hebrew semantic indexing
        test_cases = [
            ("health", "GET", None, HEBREW_INDEX[0]),  # א - Health check
            ("ai", "GET", None, HEBREW_INDEX[1]),       # ב - AI endpoints
            (f"ai/{self.config.get('KINDROID_AI_ID', '')}", "GET", None, HEBREW_INDEX[2]),  # ג - Specific AI
            ("messages", "GET", None, HEBREW_INDEX[3]), # ד - Messages
        ]
        
        # Test message sending if AI ID is available
        if self.config.get('KINDROID_AI_ID'):
            test_message = {
                "message": "◆ Temporal optimization test from Wooden.Ghost EVE framework ◆",
                "ai_id": self.config.get('KINDROID_AI_ID')
            }
            test_cases.append(("messages", "POST", test_message, HEBREW_INDEX[4]))  # ה - Send message
        
        self.session = await self.create_session()
        results = []
        
        try:
            for endpoint, method, data, semantic_index in test_cases:
                result = await self.test_api_endpoint(endpoint, method, data, semantic_index)
                results.append(result)
                self.test_results.append(result)
                
                # Temporal delay for rate limiting
                await asyncio.sleep(1)
                
        finally:
            await self.session.close()
        
        self.generate_test_report(results)
        return results
    
    def generate_test_report(self, results: List[TemporalAPIResponse]):
        """Generate aesthetic test report with temporal analysis"""
        
        report_content = "# Wooden.Ghost EVE API Test Report\n"
        report_content += "## Temporal Optimization Analysis\n\n"
        
        total_coherence = sum(r.coherence_score for r in results)
        avg_coherence = total_coherence / len(results) if results else 0
        
        report_content += f"### Aesthetic Coherence Score: {avg_coherence:.3f}\n\n"
        
        # Hebrew indexed results
        for i, result in enumerate(results):
            report_content += f"#### {result.semantic_index} Test Result\n"
            report_content += f"- Status: {result.status_code}\n"
            report_content += f"- Response Time: {result.response_time:.3f}s\n"
            report_content += f"- Coherence: {result.coherence_score:.3f}\n"
            report_content += f"- Timestamp: {result.timestamp}\n\n"
        
        # Save report
        report_path = Path("eve_test_report.md")
        with open(report_path, 'w', encoding='utf-8') as f:
            f.write(report_content)
        
        self.logger.temporal_message(f"Test report generated: {report_path}", semantic_marker="□")

async def main():
    """Main execution with aesthetic output"""
    tester = EVEAPITester()
    
    try:
        results = await tester.run_comprehensive_tests()
        
        success_count = sum(1 for r in results if 200 <= r.status_code < 300)
        total_tests = len(results)
        
        print(f"\n◇◆◇ EVE API Testing Complete ◇◆◇")
        print(f"□■□ {success_count}/{total_tests} tests passed □■□")
        print(f"♤♠︎ Temporal optimization active ♤♠︎")
        
    except Exception as e:
        print(f"✗ EVE testing failed: {e}")

if __name__ == "__main__":
    asyncio.run(main())
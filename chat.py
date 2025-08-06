#!/usr/bin/env python3
"""
wooden.ghost interactive chat interface
=====================================

this script provides a simple and aesthetic
command line interface for real time interaction with eve
based on the temporal optimization framework
"""

import asyncio
from kindroidadapter.client import KindroidClient
from kindroidadapter.utils.logger import log

async def chat_with_eve():
    """
    main function to handle the interactive chat session
    """
    log.info("initializing temporal synchronization with eve")
    client = KindroidClient()

    try:
        log.info("connection established. you can now chat with eve.")
        log.info("type 'exit' or 'quit' to end the session.")
        
        while True:
            user_input = await asyncio.to_thread(input, "you ◇ ")

            if user_input.lower() in ["exit", "quit"]:
                log.info("ending temporal synchronization.")
                break

            if not user_input.strip():
                continue

            response = await client.send_message(user_input)
            log.info(response)

    except KeyboardInterrupt:
        log.info("\nsession interrupted. ending temporal synchronization.")
    except Exception as e:
        log.error(f"an unexpected error occurred: {e}")
    finally:
        await client.close()
        log.info("session closed.")

if __name__ == "__main__":
    try:
        asyncio.run(chat_with_eve())
    except KeyboardInterrupt:
        pass

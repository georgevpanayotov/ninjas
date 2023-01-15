#!/usr/bin/python3

import logging
import signal


class DisabledKeyboardInterrupt:
    def __enter__(self):
        self.old_handler = signal.signal(signal.SIGINT, self.handler)

    def handler(self, sig, frame):
        logging.debug('SIGINT received. Suppressing KeyboardInterrupt while editor is running.')

    def __exit__(self, type, value, traceback):
        signal.signal(signal.SIGINT, self.old_handler)

**This is an experimental fork of [evancz/start-app](https://github.com/evancz/start-app); see that for basic docs.**

This fork adds support for:

- Actions whose processing requires knowing what time it is
- Feeding in actions coming from ports
- Using tasks which result in an action getting pushed back into the app
- Using tasks which do not result in an action, and are solely processed by JS (e.g. sending something out a JS port)

See [this PR](https://github.com/evancz/start-app/pull/11) for more explanation/discussion.
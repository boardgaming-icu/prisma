# boardgaming.icu DB schema

## User

|Key|Type|Explanation|
|---|----|-----------|
|id|String|A UUID identifying the specific user account|
|name|String|A username which is unique to the account|
|password|String?|A password hash which is used for login|
|disc_id|String?|The discord ID associated with the account - can be used for OAuth|
|avatar|String|The avatar displayed - https://s3.ocld.cc/boardgaming.icu/{avatar}|
|auth_token|String|Authentication token stored in JWT cookie|
|balance|Float|Balance for coins used for the avatar shop & games|
|notifications|[Notification](#notification)[]|A list of notifications for the user
|settings|Int|Bitwise int defined [here](#user_settings)|
|last_spin|BigInt|Date.now() value for the last spin of the free balance wheel|
|games|[Game](#game)[]|A list of games which the user has played in.|
|status|Int|Bitwise int defined [here](#user_status)


### User settings
|Bitwise|Means|
|-------|-----|
|1 << 0|Discord messages|
|1 << 1|Email messages|
|1 << 2|Email newsletter|

### User status
|Bitwise|Means|
|-------|-----|
|1 << 0|Administrator account|
|1 << 1|Flagged account|
|1 << 2|Verified account|

## Notification
|Key|Type|Explanation|
|---|----|-----------|
|id|String|An ID which is used to identify the notification|
|users|[User](#user)|The user(s) which the notification is for|
|head|String|Head of the notification|
|body|String|Body of the notification|
|read|Boolean|If the notification has been read|




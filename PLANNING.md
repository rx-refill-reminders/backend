# Planning

### Context

The cycle of refilling ADHD prescriptions is very tedious and has multiple steps. 

The general process is like so:
1. Pick up a prescription
2. Request the next prescription to be sent to the pharmacy, dated in advance for easy refilling
3. Wait until the prescription can be refilled, based on when it was picked up (25d after pickup)
4. Request the pharmacy to fill the prescription
5. Repeat

### Problem Statement

The goal is to create an iOS app with an AWS backend, which provides reminders throughout the process
to avoid missing a prescription.

### Basic User flow

1. Pickup
    1. Remind me to request the next refill (prescriber) - provide next refill date?
        1. Repeat until marked complete
2. Reminder to request the pharmacy to fill
3. Reminder to pickup (based on pickup date + refill interval)
4. Wait for user to mark picked up

### Interactions

1. User creates rx cycle
    1. Create next rx + schedule reminders
2. User picks up rx
    1. Create next rx + schedule reminders
3. User postpones reminder to request refill
    1. Update reminder time?
4. User ignores reminder to request refill
    1. No backend action - next reminder should already be there

### Entities

* User
    * UUID
    * Name
* Rx Cycle
    * UUID
    * Name
    * Refill interval
    * Pharmacy fill advance days
* Rx Cycle Instance
    * UUID
    * Refill requested?
    * Fill requested?
    * Picked up?
* Reminder
    * UUID
    * Timestamp
    * Next timestamp


Reminder: timestamp, giveUpTimestamp, type, state
* timestamp
* giveUpTimestamp
* done
* gaveUp

Execute a step function every hour, to send out all necessary reminders and update them as needed

### Architecture

1. iOS frontend
2. AWS backend
    1. Cognito for auth
    2. API gateway
    3. DynamoDB storage
    4. SNS notifications

### Essential Pieces

1. DNS
    1. Route53 domain
    2. Route53 hosted zones
    3. Route53 subdomains

2. User management
    1. Cognito user pool
    2. DynamoDB table for user metadata
    3. Various lambda triggers, at least post-confirmation

3. API
    1. API gateway for receiving requests
    2. Lambda for handling requests
    3. Authorizer connected to Cognito
    4. DynamoDB tables for resource storage

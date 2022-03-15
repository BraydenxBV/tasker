# tasker

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Scope

Tasker
A Flutter Project

Purpose
Tasker is a mobile app in which you list tasks you need to complete; then, start the task, and finish the task – the date and time will be recorded for each.

Tasker is a small project to facilitate learning Flutter concepts. The concept is written by James Perih.

Scope
Tasker will help the budding developer to learn:
Flutter Animations
Basic Networking
Basic OOP concepts

Developer should take about 30 hours for the entire project.

Components
Overview
Tasker is an application that will list your your tasks in a list. When you add a task, it will be added to the list. Each task has a name, a start date, and a completion date. There will be UI elements that will allow you to start the task, complete the task, or delete the task.

Tasks will be stored in-memory in a basic ExpressJs server (THIS WILL BE PROVIDED FOR YOU), and only for a single user (or, rather, ALL users will share the same list of tasks). Extra credit will be given if you can create a multi-user-capable server with as little code as possible.

Animations
It would be ideal to display an appropriate animation when a task is created, deleted, started and completed.

Basic Networking
Server
The server lives at https://flutter-tasker-server.herokuapp.com. This is referred to below as serverUrl.
List
When the app is started, request your list of tasks.
GET serverUrl/tasks

You will be given a json list of task objects, expressed as JSON:
[
   {
       "id": "<UUID>",
       "name": "My Task",
       "startedAt": 1646603485,
       "completedAt": 1646603485,
       "deletedAt": 1646603485
   },
   {
       "id": "<UUID>",
       "name": "Another Task",
       "startedAt": 1646603485,
       "completedAt": 1646603485,
       "deletedAt": 1646603485
   }
]

Create
When a task is created, push the name of the task to the server; 
POST serverUrl/tasks
{
   "name": "My Task"
}

The server will return the task with an identifier, and the created date, as JSON.

{
   "id": "<UUID>",
   "name": "My Task",
   "startedAt": null,
   "completedAt": null,
   "deletedAt": null
}

Action: Start
When a task is started, notify the server:
GET serverUrl/tasks/<UUID>/start

The server will return the task with the modified time:
{
   "id": "<UUID>",
   "name": "My Task",
   "startedAt": 1646603485,
   "completedAt": null,
   "deletedAt": null
}
Action: Complete
When a task is completed, notify the server:
GET serverUrl/tasks/<UUID>/complete

The server will return the task with the modified time:
{
   "id": "<UUID>",
   "name": "My Task",
   "startedAt": 1646603485,
   "completedAt": 1646603485,
   "deletedAt": null
}
Action: Delete
Finally, when the task is deleted, notify the server:
(we could use the DELETE REST method, but that method usually assumes no output will be given; we, however, want to get the server-modified model with the deletedAt field filled in)

GET serverUrl/tasks/<UUID>/delete

The server will respond:
{
   "id": "<UUID>",
   "name": "My Task",
   "startedAt": 1646603485,
   "completedAt": 1646603485,
   "deletedAt": 1646603485
}


Basic OOP Concepts
Tasker makes use of a Task object, which will need to store the following fields:
“id”, which is a String and cannot be null
“name”, which is a String, and cannot be null
“createdDate”, which is a Date object, and cannot be null
“startedDate”, which is a Date object, and can be null
“completedDate”, which is a Date object, and can be null
“deletedDate”, which is a Date object, and can be null

You will need to generate a factory constructor called fromJson, which takes the Json data and returns a new instance of a Task object.

Note that the four date objects should be reflected in the app as, eg, createdDate, but will display in JSON responses at “createdAt.”

We also have to send a special object to the network which includes the intended name of the task. This only requires the name field, and should have a toJson method to facilitate the POST to the server. Call it “NewTask” and give it one required String field, “name” and a public toJson method which returns the instance as a Json Map.

Design
Whatever you want! But please note:

Try not to “over-design” the app. If kept as simple as possible, we will be able to take advantage of Theming. For now, just keep it simple. We will explore theming in the next module
Keep in mind that the app will be used by android and iOS phones in both portrait and landscape. Bonus points are awarded if you accommodate the landscape orientation, as well as larger devices such as Tablets and HD screens

Schedule
Roughly 3 weeks will be provided for this project. Check-ins will be required at least once a week. Rather than attempt to complete the entire project in one week, try to break it into three logical parts, and come prepared to discuss only each part during the check-in.

Testing
Won’t be required. I need to learn testing, myself… if the code submitted is clean, we will use it to develop a testing methodology.

Evaluation
Work will be evaluated on the following criteria, in order of importance
Work is done on time, and is making continual progress
Code is clean – i can glance casually at it, and determine what each part is trying to do
App works properly – the functions work as expected. The app runs on the simulator with no issues on the first try.
Git commits are clean – i can scan the commit history, and see the type and nature of work that was done, and be able to discern where the difficulty areas were
App is a delight to use – efficient and clever use of the UI elements, everything feels snappy and not sluggish

Each element will be given a score from 1 - 5, with a total score of 25, and room for 5 bonus points (for a potential score of 30, or 120%). A passing grade is 15, and will permit the developer to move onto the next project. A grade of less than 15 will require some discussion points and coaching.


## Task Definition

An example ECS task definition for running the application behind an nginx reverse caching proxy.

```
{
  "containerDefinitions": [
     {
       "name": "nginx",
       "image": "<NGINX reverse proxy image URL here>",
       "memory": "256",
       "cpu": "256",
       "essential": true,
       "portMappings": [
         {
           "containerPort": "80",
           "protocol": "tcp"
         }
       ],
       "links": [
         "sinatra"
       ]
     },
     {
       "name": "sinatra",
       "image": "<app image URL here>",
       "memory": "256",
       "cpu": "256",
       "environment": [
         { "name": "LOG_LEVEL", "value": "INFO" },
         { "name": "LIST_CACHE_EXPIRY", "value": 3600 },
         { "name": "MATCH_CACHE_EXPIRY", "value": 120 }
       ],
       "essential": true
     }
   ],
   "networkMode": "bridge",
   "family": "cricket-scoreboard"
}
```

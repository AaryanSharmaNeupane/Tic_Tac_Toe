from django.urls import path 
from .consumers import GameRoomConsumer

websocket_urlpatterns=[
    path('ws/notification/',GameRoomConsumer.as_asgi())
]
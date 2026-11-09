#from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny

# Django health check view class

class HealthCheckView(APIView):
    authentication_classes = []
    permission_classes = [AllowAny]

    def get(self, request):
        return Response({
            "status": "healthy",
            "application": "Football OS",
            "version": "1.0.0",
            "message": "Football OS backend is running.",
            })


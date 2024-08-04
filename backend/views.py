from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from .utils import read_data, order_box, order_size
import json

class HealthCheckView(APIView):
    def get(self, request, *args, **kwargs):
        return Response({'status': 'OK'}, status=status.HTTP_200_OK)
    
class MagazinesView(APIView):
    def get(self, request, *args, **kwargs):
        data = read_data()
        return Response(json.loads(data))

class OrderSizeView(APIView):
    def post(self, request, *args, **kwargs):
        status = order_size(request.data["size"])
        return Response({"status": status})
    
class OrderBoxView(APIView):
    def post(self, request, *args, **kwargs):
        status = order_box(request.data["magazine"], request.data["id"]) 
        return Response({"status": status})
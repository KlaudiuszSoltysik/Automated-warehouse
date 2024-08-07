from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from .utils import read_data, order_box, order_size
import json
    
class MagazinesView(APIView):
    def get(self, request, *args, **kwargs):
        data = read_data()
        return Response(json.loads(data), status=status.HTTP_200_OK)

class OrderSizeView(APIView):
    def post(self, request, *args, **kwargs):
        if order_size(request.data['box_size']):
            return Response(status=status.HTTP_200_OK)
        return(Response(status=status.HTTP_400_BAD_REQUEST))
    
class OrderBoxView(APIView):
    def post(self, request, *args, **kwargs):
        if order_box(request.data['ID'], request.data['magazine']):
            return Response(status=status.HTTP_200_OK)
        return(Response(status=status.HTTP_400_BAD_REQUEST))
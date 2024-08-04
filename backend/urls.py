from django.contrib import admin
from django.urls import path
from .views import HealthCheckView, MagazinesView, OrderSizeView, OrderBoxView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('health/', HealthCheckView.as_view()),
    path('magazines/', MagazinesView.as_view()),
    path('order_size/', OrderSizeView.as_view()),
    path('order_box/', OrderBoxView.as_view()),
]
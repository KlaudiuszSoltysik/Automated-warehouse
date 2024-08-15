from django.contrib import admin
from django.urls import path
from .views import MagazinesView, OrderSizeView, OrderBoxView, UpdateMagazineLocksView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('magazines/', MagazinesView.as_view()),
    path('order_size/', OrderSizeView.as_view()),
    path('order_box/', OrderBoxView.as_view()),
    path('update_magazine_locks/', UpdateMagazineLocksView.as_view()),
]
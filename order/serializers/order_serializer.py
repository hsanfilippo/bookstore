from rest_framework import serializers

from order.models import Order
from product.serializers.product_serializer import ProductSerializer


class OrderSerializer(serializers.ModelSerializer):
    # No corpo dessa classe, serão passados apenas os campos que serão
    # alterados. Caso nenhum campo seja passado, seguirá o padrão presente
    # no model.

    product = ProductSerializer(required=True, many=True)
    total = serializers.SerializerMethodField()

    def get_total(self, instance):
        total = sum([product.price for product in instance.product.all()])
        return total

    class Meta:
        model = Order
        fields = ['product', 'total']

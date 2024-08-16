from attr.setters import validate
from rest_framework import serializers

from order.models import Order
from product.models import Product
from product.serializers.product_serializer import ProductSerializer


class OrderSerializer(serializers.ModelSerializer):
    # No corpo dessa classe, serão passados apenas os campos que serão
    # alterados. Caso nenhum campo seja passado, seguirá o padrão presente
    # no model.

    product = ProductSerializer(required=True, many=True)
    products_id = serializers.PrimaryKeyRelatedField(queryset=Product.objects.all(), write_only=True, many=True)
    total = serializers.SerializerMethodField()

    # Metodo que soma o valor total de todos os produtos.
    def get_total(self, instance):
        total = sum([product.price for product in instance.product.all()])
        return total

    class Meta:
        model = Order
        fields = ['product', 'total', 'user', 'id']
        extra_kwargs = {'product': {'required': False}}

    def create(self, validated_data):
        product_data = validated_data.pop('products_id')
        user_data = validated_data.pop('user')

        order = Order.objects.create(validated_data)
        for product in product_data:
            order.product.add(product)

        return order

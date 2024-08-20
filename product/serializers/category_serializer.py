from rest_framework import serializers

from product.models.category import Category


class CategorySerializer(serializers.ModelSerializer):
    # Como não houve a necessidade de alterar nada, apenas
    # especifiquei na 'class Meta' os campos que serão exibidos
    # no JSON gerado por esse serializer.
    class Meta:
        model = Category
        fields = [
            'title',
            'slug',
            'description',
            'active'
        ]
        extra_kwargs = {"slug": {"required": False}}
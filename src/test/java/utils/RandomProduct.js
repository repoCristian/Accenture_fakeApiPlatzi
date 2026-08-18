

function createRandomProduct(){
    var uniqueId = karate.uuid();
    return {
        title: 'Producto Karate' + uniqueId,
        price: 99,
        description: 'Producto creado desde automatización - ' + uniqueId,
        categoryId: 5,
        images: ['https://placehold.co/600x400']
    };
}
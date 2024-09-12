#include <iostream>
#include <list>
#include "./apis/geo/shape.h"
#include "./models/geo/circle.h"
#include "./models/geo/rectangle.h"
#include "./models/geo/triangle.h"
#include "./models/geo/composite.h"

int main(void)
{
    std::list<Shape *> list = {new Rectangle(5, 7), new Triangle(5, 7), new Circle(10)};

    auto s = new Composite(list);

    std::cout << "Total area: " << s->getArea() << std::endl;

    return 0;
}

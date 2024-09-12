#pragma once
#include <list>
#include <iostream>
#include "../../apis/geo/shape.h"

class Composite : public Shape
{
private:
    std::list<Shape *> shapes;

public:
    Composite(std::list<Shape *> shapes)
    {
        this->shapes = shapes;
    }

    ~Composite()
    {
        std::cout << "Circle is being deleted" << std::endl;
    }

public:
    float getArea()
    {
        float result = 0;
        for (auto s : this->shapes)
        {
            result += s->getArea();
        }
        return result;
    }
};
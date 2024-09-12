#pragma once
#include <iostream>
#include "../../apis/geo/shape.h"

const float PI = 3.1415;

class Circle : public Shape
{
private:
    float radio;

public:
    Circle(float radio)
    {
        this->radio = radio;
    }

    ~Circle()
    {
        std::cout << "Circle is being deleted" << std::endl;
    }

public:
    float getArea()
    {
        return PI * 2.0 * this->radio;
    }
};
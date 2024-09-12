#pragma once
#include <iostream>
#include "../../apis/geo/shape.h"

class Triangle : public Shape
{
private:
    int width;
    int height;

public:
    Triangle(int width, int height)
    {
        this->height = height;
        this->width = width;
    }

    ~Triangle()
    {
        std::cout << "Triangle is being deleted" << std::endl;
    }

public:
    float getArea()
    {
        return (this->width * this->height) / 2;
    }
};
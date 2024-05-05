#pragma once
#include <iostream>
#include <string>
#include <vector>
#include <memory>
#include <cmath> 
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>


// Forward declaration of Components
namespace Components {
    struct BaseComponent;
    struct Transform;
    struct Physics;
    struct BoxCollider;
    struct CircleCollider;
    struct CapsuleCollider;
}

// Namespace for the Magma Game Engine
namespace Magma {

    // Forward declaration of the Init function
    void Init();

    // Nested namespace for types used in Magma
    namespace Types {

        // Class representing a 2D vector
        class Vec2 {
        private:
            unsigned int X; // X coordinate
            unsigned int Y; // Y coordinate
        public:
            Vec2(unsigned int X, unsigned int Y); // Constructor
            unsigned int GetX() const; // Getter for X coordinate
            unsigned int GetY() const; // Getter for Y coordinate
            void SetX(unsigned int X); // Setter for X coordinate
            void SetY(unsigned int Y); // Setter for Y coordinate
        };

        // Class representing an RGBA color
        class RgbaColor {
        private:
            SDL_Color Color = { 0, 0, 0, 0 }; // SDL_color with RGBA components
        public:
            RgbaColor(unsigned int Red, unsigned int Green, unsigned int Blue, unsigned int Alpha); // Constructor
            unsigned int GetRed() const; // Getter for red component
            unsigned int GetGreen() const; // Getter for green component
            unsigned int GetBlue() const; // Getter for blue component
            unsigned int GetAlpha() const; // Getter for alpha component
            void SetRed(unsigned int Red); // Setter for red component
            void SetGreen(unsigned int Green); // Setter for green component
            void SetBlue(unsigned int Blue); // Setter for blue component
            void SetAlpha(unsigned int Alpha); // Setter for alpha component
        };
    }

    // Namespace for components used in Magma
    namespace Components {
        namespace Internal {

            // Base struct representing a component
            static struct BaseComponent {
                virtual ~BaseComponent() {} // Virtual destructor for polymorphism
            };
        }

        // Struct representing a Transform component
        struct Transform : public Internal::BaseComponent {
            Types::Vec2 Position; // Position of the entity
            float Rotation;       // Rotation of the entity
            float Scale;          // Scale of the entity
            void MoveTo(const Types::Vec2& Position);
            void MoveBy(const Types::Vec2& Offset);
        };

        // Struct representing a Physics component
        struct Physics : public Internal::BaseComponent {
            float Gravity = 9.81; // Earth's Gravitational Constant In m/s
            float Mass; // Object's Mass in Pounds
        };

        // Struct representing a Box collider component
        struct BoxCollider : public Internal::BaseComponent {
            Types::Vec2 Point1; // First corner of the box collider
            Types::Vec2 Point2; // Second corner of the box collider
            Types::Vec2 Point3; // Third corner of the box collider
            Types::Vec2 Point4; // Fourth corner of the box collider
        };

        // Struct representing a Circle collider component
        struct CircleCollider : public Internal::BaseComponent {
            float Diameter; // Diameter of the circle collider
        };

        // Struct representing a Capsule collider component
        struct CapsuleCollider : public Internal::BaseComponent {
            Types::Vec2 center;    // Center position of the capsule
            float orientation;     // Orientation angle of the capsule
            float length;          // Length of the capsule
            float radius;          // Radius of the capsule
        };
    }

    class Entity {
    private:
        std::string Name;
        std::vector<std::shared_ptr<Components::Internal::BaseComponent>> Components;
    public:
        void SetName(std::string Name);
        void AddComponent(const std::shared_ptr<Components::Internal::BaseComponent>& Component);
        std::vector<std::shared_ptr<Components::Internal::BaseComponent>> GetComponentList();
    };

    class Renderer {
    private:
        SDL_Window* WindowContext;
        SDL_Renderer* RendererContext;
        std::vector<Entity> RenderCach;
    public:
        Renderer(const char* Title, Types::Vec2 WindowCreationOrgin, unsigned int WindowWidth, unsigned int WindowHeight, bool Fullscreen);
        ~Renderer();
        void AddToRendererCache(Entity Entity);
        void Update();
        void Clear(Types::RgbaColor ClearColor);
    };

} // End of namespace Magma
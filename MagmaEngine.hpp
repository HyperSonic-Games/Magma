#pragma once

namespace Magma {

    class Scene {
    private:
        unsigned int P_SceneX;
        unsigned int P_SceneY;
        const char* P_Title;
        SDL_Window* P_MagmaWindow;
        std::vector<const char*> P_EntityIDs;
        unsigned int P_FpsTarget;

    public:
        Scene(const char* Title, unsigned int SceneX, unsigned int SceneY, unsigned int FpsTarget = 60);
        ~Scene();

        const char* GetTitle() const;
        int GetX() const;
        int GetY() const;
        SDL_Window* GetMagmaWindow();
        std::vector<const char*> GetEntityIDs() const;
        void AddID(const char* EntityID);
        void RemoveID(const char* EntityID);
    };

    class Entity {
    private:
        const char* P_EntityID;
        int P_EntityX;
        int P_EntityY;
        Scene& P_Scene;

    public:
        Entity(const char* EntityID, int EntityX, int EntityY, Scene& Scene);
        ~Entity();
    };

    class Renderer {
    private:
        SDL_Renderer* P_SDLRenderer;

    public:
        Renderer(SDL_Window* window);
        ~Renderer();

        void Clear() const;
        void Render() const;
        void DrawRect(int x, int y, int width, int height) const;
        // Add more rendering methods as needed (images, textures, etc.)
    };

}  // namespace Magma

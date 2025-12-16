package Audio

import "vendor:sdl2/mixer"
import "vendor:sdl2"

import "../../Util"

AudioContext :: struct {
    FX:        i32,
    Background:i32,
    Voice:     i32,
    Ambience:  i32,
    UI:        i32,
    Custom1:   i32,
    Custom2:   i32,
    Custom3:   i32,
    Music:     ^mixer.Music,

    // Stored chunks for each logical channel
    FXChunk:        ^mixer.Chunk,
    BackgroundChunk:^mixer.Chunk,
    VoiceChunk:     ^mixer.Chunk,
    AmbienceChunk:  ^mixer.Chunk,
    UIChunk:        ^mixer.Chunk,
    Custom1Chunk:   ^mixer.Chunk,
    Custom2Chunk:   ^mixer.Chunk,
    Custom3Chunk:   ^mixer.Chunk
}

/*
 * ShowVersionInfo prints the compiled and linked SDL2_mixer version
 */
@private
@init
ShowVersionInfo :: proc() {
    compiled_version_major := mixer.MAJOR_VERSION
    compiled_version_minor := mixer.MINOR_VERSION
    compiled_version_patch := mixer.PATCHLEVEL
    currently_linked_version := mixer.Linked_Version()
    Util.log(
        .INFO,
        "MAGMA_2D_AUDIO_SHOW_VERSION_INFO",
        "\nCompiled with SDL2_mixer version: %d:%d:%d\nCurrently linked with SDL2_mixer version: %d:%d:%d",
        compiled_version_major,
        compiled_version_minor,
        compiled_version_patch,
        currently_linked_version.major,
        currently_linked_version.minor,
        currently_linked_version.patch
    )
}

/*
 * Init initializes the SDL2_mixer audio system and returns a new AudioContext
 * @return ^AudioContext A pointer to the initialized audio context
 */
Init :: proc() -> ^AudioContext {
    flags: mixer.InitFlags = {.OPUS, .OGG, .MP3, .FLAC}
    ret_flags := mixer.Init(flags)
    if transmute(mixer.InitFlags)ret_flags != flags {
        Util.log(.ERROR, "MAGMA_2D_AUDIO_INIT", "Could not init all audio. Got: %v, Expected: %v", ret_flags, flags)
    }

    ctx := new(AudioContext)
    ctx.FX         = 0
    ctx.Background = 1
    ctx.Voice      = 2
    ctx.Ambience   = 3
    ctx.UI         = 4
    ctx.Custom1    = 5
    ctx.Custom2    = 6
    ctx.Custom3    = 7
    ctx.Music      = nil

    // Initialize all chunks to nil
    ctx.FXChunk         = nil
    ctx.BackgroundChunk = nil
    ctx.VoiceChunk      = nil
    ctx.AmbienceChunk   = nil
    ctx.UIChunk         = nil
    ctx.Custom1Chunk    = nil
    ctx.Custom2Chunk    = nil
    ctx.Custom3Chunk    = nil

    return ctx
}


/*
 * Shutdown cleans up the audio system and frees all loaded chunks and music
 * @param ctx The AudioContext to shut down
 */
Shutdown :: proc(ctx: ^AudioContext) {
    // Free music
    if ctx.Music != nil {
        mixer.FreeMusic(ctx.Music)
        ctx.Music = nil
    }

    mixer.FreeChunk(ctx.AmbienceChunk)
    mixer.FreeChunk(ctx.BackgroundChunk)
    mixer.FreeChunk(ctx.Custom1Chunk)
    mixer.FreeChunk(ctx.Custom2Chunk)
    mixer.FreeChunk(ctx.Custom3Chunk)
    mixer.FreeChunk(ctx.FXChunk)
    mixer.FreeChunk(ctx.UIChunk)
    mixer.FreeChunk(ctx.VoiceChunk)

    // Stop all channels
    for i in 0..<mixer.CHANNELS {
        mixer.HaltChannel(cast(i32)i)
    }

    // Quit SDL_mixer
    mixer.Quit()
}



/*
 * LoadFX loads a WAV file into the FX channel
 * @param ctx The AudioContext
 * @param wav_file Path to the WAV file
 */
LoadFX :: proc(ctx: ^AudioContext, wav_file: cstring) {
    ctx.FXChunk = mixer.LoadWAV(wav_file)
}

/*
 * LoadBackground loads a WAV file into the Background channel
 * @param ctx The AudioContext
 * @param wav_file Path to the WAV file
 */
LoadBackground :: proc(ctx: ^AudioContext, wav_file: cstring) {
    ctx.BackgroundChunk = mixer.LoadWAV(wav_file)
}

/*
 * LoadVoice loads a WAV file into the Voice channel
 * @param ctx The AudioContext
 * @param wav_file Path to the WAV file
 */
LoadVoice :: proc(ctx: ^AudioContext, wav_file: cstring) {
    ctx.VoiceChunk = mixer.LoadWAV(wav_file)
}

/*
 * LoadAmbience loads a WAV file into the Ambience channel
 * @param ctx The AudioContext
 * @param wav_file Path to the WAV file
 */
LoadAmbience :: proc(ctx: ^AudioContext, wav_file: cstring) {
    ctx.AmbienceChunk = mixer.LoadWAV(wav_file)
}

/*
 * LoadUI loads a WAV file into the UI channel
 * @param ctx The AudioContext
 * @param wav_file Path to the WAV file
 */
LoadUI :: proc(ctx: ^AudioContext, wav_file: cstring) {
    ctx.UIChunk = mixer.LoadWAV(wav_file)
}

/*
 * LoadCustom1 loads a WAV file into the Custom1 channel
 * @param ctx The AudioContext
 * @param wav_file Path to the WAV file
 */
LoadCustom1 :: proc(ctx: ^AudioContext, wav_file: cstring) {
    ctx.Custom1Chunk = mixer.LoadWAV(wav_file)
}

/*
 * LoadCustom2 loads a WAV file into the Custom2 channel
 * @param ctx The AudioContext
 * @param wav_file Path to the WAV file
 */
LoadCustom2 :: proc(ctx: ^AudioContext, wav_file: cstring) {
    ctx.Custom2Chunk = mixer.LoadWAV(wav_file)
}

/*
 * LoadCustom3 loads a WAV file into the Custom3 channel
 * @param ctx The AudioContext
 * @param wav_file Path to the WAV file
 */
LoadCustom3 :: proc(ctx: ^AudioContext, wav_file: cstring) {
    ctx.Custom3Chunk = mixer.LoadWAV(wav_file)
}



/*
 * PlayFX plays the FX channel if it has a loaded chunk
 * @param ctx The AudioContext
 */
PlayFX :: proc(ctx: ^AudioContext) {
    if ctx.FXChunk != nil {
        mixer.PlayChannel(ctx.FX, ctx.FXChunk, 0)
    }
}

/*
 * PlayBackground plays the Background channel if it has a loaded chunk
 * @param ctx The AudioContext
 */
PlayBackground :: proc(ctx: ^AudioContext) {
    if ctx.BackgroundChunk != nil {
        mixer.PlayChannel(ctx.Background, ctx.BackgroundChunk, 0)
    }
}

/*
 * PlayVoice plays the Voice channel if it has a loaded chunk
 * @param ctx The AudioContext
 */
PlayVoice :: proc(ctx: ^AudioContext) {
    if ctx.VoiceChunk != nil {
        mixer.PlayChannel(ctx.Voice, ctx.VoiceChunk, 0)
    }
}

/*
 * PlayAmbience plays the Ambience channel if it has a loaded chunk
 * @param ctx The AudioContext
 */
PlayAmbience :: proc(ctx: ^AudioContext) {
    if ctx.AmbienceChunk != nil {
        mixer.PlayChannel(ctx.Ambience, ctx.AmbienceChunk, 0)
    }
}

/*
 * PlayUI plays the UI channel if it has a loaded chunk
 * @param ctx The AudioContext
 */
PlayUI :: proc(ctx: ^AudioContext) {
    if ctx.UIChunk != nil {
        mixer.PlayChannel(ctx.UI, ctx.UIChunk, 0)
    }
}

/*
 * PlayCustom1 plays the Custom1 channel if it has a loaded chunk
 * @param ctx The AudioContext
 */
PlayCustom1 :: proc(ctx: ^AudioContext) {
    if ctx.Custom1Chunk != nil {
        mixer.PlayChannel(ctx.Custom1, ctx.Custom1Chunk, 0)
    }
}

/*
 * PlayCustom2 plays the Custom2 channel if it has a loaded chunk
 * @param ctx The AudioContext
 */
PlayCustom2 :: proc(ctx: ^AudioContext) {
    if ctx.Custom2Chunk != nil {
        mixer.PlayChannel(ctx.Custom2, ctx.Custom2Chunk, 0)
    }
}

/*
 * PlayCustom3 plays the Custom3 channel if it has a loaded chunk
 * @param ctx The AudioContext
 */
PlayCustom3 :: proc(ctx: ^AudioContext) {
    if ctx.Custom3Chunk != nil {
        mixer.PlayChannel(ctx.Custom3, ctx.Custom3Chunk, 0)
    }
}


/*
 * LoadMusicFromOpus loads an Opus file into the Music context
 * @param ctx The AudioContext
 * @param opus_file Path to the Opus file
 */
LoadMusicFromOpus :: proc(ctx: ^AudioContext, opus_file: cstring) {
    // Free existing music if any
    if ctx.Music != nil {
        mixer.FreeMusic(ctx.Music)
        ctx.Music = nil
    }

    // Load the Opus file as Mix_Music
    music := mixer.LoadMUS(opus_file)
    if music == nil {
        Util.log(.ERROR, "MAGMA_2D_AUDIO_LOAD_MUSIC_FROM_OPUS", "Failed to load music: %s", opus_file)
        return
    }
    ctx.Music = music
}

/*
 * LoadMusicFromOgg loads an OGG file into the Music context
 * @param ctx The AudioContext
 * @param ogg_file Path to the OGG file
 */
LoadMusicFromOgg :: proc(ctx: ^AudioContext, ogg_file: cstring) {
    // Free existing music if any
    if ctx.Music != nil {
        mixer.FreeMusic(ctx.Music)
        ctx.Music = nil
    }

    // Load the OGG file as Mix_Music
    music := mixer.LoadMUS(ogg_file)
    if music == nil {
        Util.log(.ERROR, "MAGMA_2D_AUDIO_LOAD_MUSIC_FROM_OGG", "Failed to load music: %s", ogg_file)
        return
    }

    ctx.Music = music
}

/*
 * LoadMusicFromMP3 loads an MP3 file into the Music context
 * @param ctx The AudioContext
 * @param mp3_file Path to the MP3 file
 */
LoadMusicFromMP3 :: proc(ctx: ^AudioContext, mp3_file: cstring) {
    // Free existing music if any
    if ctx.Music != nil {
        mixer.FreeMusic(ctx.Music)
        ctx.Music = nil
    }

    // Load the MP3 file as Mix_Music
    music := mixer.LoadMUS(mp3_file)
    if music == nil {
        Util.log(.ERROR, "MAGMA_2D_AUDIO_LOAD_MUSIC_FROM_OOG", "Failed to load music: %s", mp3_file)
        return
    }

    ctx.Music = music
}

/*
 * LoadMusicFromFLAC loads a FLAC file into the Music context
 * @param ctx The AudioContext
 * @param flac_file Path to the FLAC file
 */
LoadMusicFromFLAC :: proc(ctx: ^AudioContext, flac_file: cstring) {
    // Free existing music if any
    if ctx.Music != nil {
        mixer.FreeMusic(ctx.Music)
        ctx.Music = nil
    }

    // Load the FLAC file as Mix_Music
    music := mixer.LoadMUS(flac_file)
    if music == nil {
        Util.log(.ERROR, "MAGMA_2D_AUDIO_LOAD_MUSIC_FROM_FLAC", "Failed to load music: %s", flac_file)
        return
    }

    ctx.Music = music
}

/*
 * PlayMusic plays the currently loaded music for a given number of loops
 * @param ctx The AudioContext
 * @param loops Number of times to loop the music (-1 for infinite)
 */
PlayMusic :: proc(ctx: AudioContext, loops: i32) {
    mixer.PlayMusic(ctx.Music, loops)
}

/*
 * ToggleMusic pauses or resumes the currently loaded music
 * @param ctx The AudioContext
 */
ToggleMusic :: proc(ctx: ^AudioContext) {
    if ctx.Music == nil {
        Util.log(.WARN, "MAGMA_2D_AUDIO_TOGGLE_MUSIC", "Can't toggle music when music is nil")
        return // No music loaded
    }

    if mixer.PausedMusic() != 0 {  // returns non-zero if paused
        mixer.ResumeMusic()
    } else {
        mixer.PauseMusic()
    }
}

/*
 * StopMusic stops the music that is currently playing
 * @param ctx The AudioContext that is managing the music you want to stop
 */
StopMusic :: proc(ctx: ^AudioContext) {
    if ctx.Music != nil {
        mixer.HaltMusic()      // Stop playback immediately
        mixer.FreeMusic(ctx.Music)  // Free the memory
        ctx.Music = nil        // Clear the reference
    }
}

float atmoFog(positionVectors posVec, float viewPosLength){
    #ifdef NETHER
        float c = 0.16; float b = 0.08; float o = 0.4;
    #elif defined END
        float c = 0.1; float b = 0.05; float o = 0.4;
    #else
        float c = 0.08; float b = 0.08; float o = 0.64;
    #endif
    float fogAmount = c * exp(-posVec.viewPos.y * b) * (1.0 - exp(-viewPosLength * posVec.worldPos.y * b)) / posVec.worldPos.y;
    return saturate(fogAmount) * o;
}

vec3 getFog(positionVectors posVec, vec3 color, vec3 fogCol){
    float isSkyDepth = float(getDepth(posVec.st) == 1.0);
    float skyMask = max(getSkyMask(posVec.st) - isSkyDepth, 0.0);
    float viewPosLength = length(posVec.viewPos);
    #ifdef NETHER
        float fogNear = 64.0; float fogFar = 16.0;
        fogNear = max(far - fogNear, 0.0);
        fogFar = max(far - fogFar, 0.0);
    #elif defined END
        float fogNear = 48.0; float fogFar = 16.0;
        fogNear = max(far - fogNear, 0.0);
        fogFar = max(far - fogFar, 0.0);
    #else
        float fogNear = 32.0; float fogFar = 16.0;
        fogNear = max(far - fogNear, 0.0) * (1.0 - skyMask) + 128.0 * skyMask;
        fogFar = max(far - fogFar, 0.0) * (1.0 - skyMask) + 160.0 * skyMask;
    #endif

    float fogAmount = smoothstep(fogNear, fogFar, viewPosLength);
    float mistFog = atmoFog(posVec, viewPosLength);
    color = mix(color, sqrt(fogCol), mistFog);
    
    return color * (1.0 - fogAmount) + fogCol * fogAmount;
}
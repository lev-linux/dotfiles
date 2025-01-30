#version 120

// Uniforms
uniform sampler2D texture;
uniform sampler2D desktop;
uniform vec2 screenSize;
uniform vec2 mouse;

// Varying
varying vec2 uvCoord;

// Adjustable parameters
const vec2 BOX_SIZE = vec2(128, 128);
const vec2 BOX_OFFSET = vec2(-64, -64);
const float MAG_STRENGTH = 5.0;
const vec2 BORDER_SIZE = vec2(1, 1);
const vec4 BORDER_COLOR = vec4(0, 0, 0, 1);
const bool CROSSHAIR = true;

// Utility Functions
vec2 toUVSpace(vec2 value) {
    return value / screenSize;
}

vec2 getMouseUV() {
    return vec2(mouse.x, -mouse.y) / screenSize + vec2(0, 1);
}

bool isInsideBox(vec2 uv, vec2 boxPos, vec2 boxSize) {
    return uv.x < boxPos.x + boxSize.x &&
           uv.x > boxPos.x &&
           uv.y > boxPos.y &&
           uv.y < boxPos.y + boxSize.y;
}

bool isOnBorder(vec2 uv, vec2 boxPos, vec2 boxSize, vec2 borderSize) {
    return uv.x <= boxPos.x + boxSize.x + borderSize.x &&
           uv.x >= boxPos.x - borderSize.x &&
           uv.y >= boxPos.y - borderSize.y &&
           uv.y <= boxPos.y + boxSize.y + borderSize.y;
}

bool isInCrosshair(vec2 uv, vec2 center, vec2 borderSize) {
    return abs(uv.x - center.x) < borderSize.x || abs(uv.y - center.y) < borderSize.y;
}

vec4 getZoomedColor(vec2 uv, vec2 mouseUV, vec2 boxOffset, vec2 boxSize, float magStrength) {
    vec2 zoomedUV = ((uv - mouseUV) - (boxOffset + boxSize / 2)) / magStrength + mouseUV;
    vec2 zoomedUVFlipped = vec2(zoomedUV.x, -zoomedUV.y);
    vec4 rectColor = texture2D(texture, zoomedUV);
    return mix(texture2D(desktop, zoomedUVFlipped), rectColor, rectColor.a);
}

// Main Function
void main() {
    vec2 boxOffsetUV = toUVSpace(BOX_OFFSET);
    vec2 boxSizeUV = toUVSpace(BOX_SIZE);
    vec2 borderSizeUV = toUVSpace(BORDER_SIZE);
    vec2 mouseUV = getMouseUV();

    vec4 color;

    // Determine the current region
    if (isInsideBox(uvCoord, mouseUV + boxOffsetUV, boxSizeUV)) {
        // Inside magnified box
        vec2 center = mouseUV + boxOffsetUV + boxSizeUV / 2.0;
        if (isInCrosshair(uvCoord, center, borderSizeUV) && CROSSHAIR) {
            color = BORDER_COLOR;
        } else {
            color = getZoomedColor(uvCoord, mouseUV, boxOffsetUV, boxSizeUV, MAG_STRENGTH);
        }
    } else if (isOnBorder(uvCoord, mouseUV + boxOffsetUV, boxSizeUV, borderSizeUV)) {
        // On the border of the box
        color = BORDER_COLOR;
    } else if (isInCrosshair(uvCoord, mouseUV, borderSizeUV) && CROSSHAIR) {
        // Global crosshair
        color = BORDER_COLOR;
    } else {
        // Base texture
        color = texture2D(texture, uvCoord);
    }

    gl_FragColor = color;
}

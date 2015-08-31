/*
 * Copyright (C) 
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#include <jni.h>
#include <math.h>
#include <android/log.h>

#include <stdio.h>
#include <stdlib.h>

#include <mem_utils.h>
#include <bitmap.h>

#define  ENABLE_LOG 0
#define  LOG_TAG    "bitmap.c"

#if ENABLE_LOG
    #define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
    #define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)
#else
    #define  LOGI(...)
    #define  LOGE(...)
#endif

inline int rgb(int red, int green, int blue) {
	return (0xFF << 24) | (red << 16) | (green << 8) | blue;
}

inline unsigned char red(int color) {
	return (unsigned char)((color >> 16) & 0xFF);
}

inline unsigned char green(int color) {
	return (unsigned char)((color >> 8) & 0xFF);
}

inline unsigned char blue(int color) {
	return (unsigned char)(color & 0xFF);
}

int getPixelAsInt(Bitmap* bitmap, int x, int y) {
	unsigned int pos = ((*bitmap).width * y) + x;

	return rgb((int)(*bitmap).red[pos], (int)(*bitmap).green[pos], (int)(*bitmap).blue[pos]);
}

static void getScaledSize(int srcWidth, int srcHeight, int numPixels, int* dstWidth, int* dstHeight) {
	float ratio = (float)srcWidth/srcHeight;

	*dstHeight = (int)sqrt((float)numPixels/ratio);
	*dstWidth = (int)(ratio * sqrt((float)numPixels/ratio));
}

void deleteBitmap(Bitmap* bitmap) {
	freeUnsignedCharArray(&(*bitmap).red);
	freeUnsignedCharArray(&(*bitmap).green);
	freeUnsignedCharArray(&(*bitmap).blue);
	freeUnsignedCharArray(&(*bitmap).transformList.transforms);
	(*bitmap).transformList.size = 0;
	(*bitmap).width = 0;
	(*bitmap).height = 0;
}

int initBitmapMemory(Bitmap* bitmap, int width, int height) {
	deleteBitmap(bitmap);

	(*bitmap).width = width;
	(*bitmap).height = height;

	(*bitmap).redWidth = width;
	(*bitmap).redHeight = height;

	(*bitmap).greenWidth = width;
	(*bitmap).greenHeight = height;

	(*bitmap).blueWidth = width;
	(*bitmap).blueHeight = height;

	int size = width*height;

	int resultCode = newUnsignedCharArray(size, &(*bitmap).red);
	if (resultCode != MEMORY_OK) {
		return resultCode;
	}

	resultCode = newUnsignedCharArray(size, &(*bitmap).green);
	if (resultCode != MEMORY_OK) {
		return resultCode;
	}

	resultCode = newUnsignedCharArray(size, &(*bitmap).blue);
	if (resultCode != MEMORY_OK) {
		return resultCode;
	}
}

int decodeResizeImage(char const *filename, int maxPixels, Bitmap* bitmap) {
    LOGI("decodeResizeImage. START");
	int returnCode;

	int maxWidth;
	int maxHeight;
    
    // Decode Image
    returnCode = decodeImage(filename, bitmap);
    
	if (returnCode != MEMORY_OK) {
		LOGE("Failed to decode image");
		freeUnsignedCharArray(&(*bitmap).red);
		freeUnsignedCharArray(&(*bitmap).green);
		freeUnsignedCharArray(&(*bitmap).blue);
		return returnCode;
	}
    LOGI("decodeResizeImage. IMAGE DECODED");
   
	doTransforms(bitmap, 1, 0, 0);
	// Resize red channel
	getScaledSize((*bitmap).redWidth, (*bitmap).redHeight, maxPixels, &maxWidth, &maxHeight); //We only need to do this once as r, g, b should be the same sizes
	returnCode = resizeChannel(&(*bitmap).red, (*bitmap).redWidth, (*bitmap).redHeight, maxWidth, maxHeight);
	if (returnCode != MEMORY_OK) {
		freeUnsignedCharArray(&(*bitmap).red);
		return returnCode;
	}
	// Set red channel dimensions
	if ((*bitmap).redWidth >= maxWidth && (*bitmap).redHeight >= maxHeight) {
		(*bitmap).redWidth = maxWidth;
		(*bitmap).redHeight = maxHeight;
	}
    LOGI("decodeResizeImage. RED COMPLETE");
    
    /**
     * GREEN CHANNEL
     */
	doTransforms(bitmap, 0, 1, 0);
	// Resize green channel
	returnCode = resizeChannel(&(*bitmap).green, (*bitmap).greenWidth, (*bitmap).greenHeight, maxWidth, maxHeight);
	if (returnCode != MEMORY_OK) {
		freeUnsignedCharArray(&(*bitmap).red);
		freeUnsignedCharArray(&(*bitmap).green);
		return returnCode;
	}
	// Set green channel dimensions
	if ((*bitmap).greenWidth >= maxWidth && (*bitmap).greenHeight >= maxHeight) {
		(*bitmap).greenWidth = maxWidth;
		(*bitmap).greenHeight = maxHeight;
	}
    LOGI("decodeResizeImage. GREEN COMPLETE");
    
    
    /**
     * BLUE CHANNEL
     */
	doTransforms(bitmap, 0, 0, 1);
	// Resize blue channel
	returnCode = resizeChannel(&(*bitmap).blue, (*bitmap).blueWidth, (*bitmap).blueHeight, maxWidth, maxHeight);
	if (returnCode != MEMORY_OK) {
		freeUnsignedCharArray(&(*bitmap).red);
		freeUnsignedCharArray(&(*bitmap).green);
		freeUnsignedCharArray(&(*bitmap).blue);
		return returnCode;
	}
	// Set blue channel dimensions
	if ((*bitmap).blueWidth >= maxWidth && (*bitmap).blueHeight >= maxHeight) {
		(*bitmap).blueWidth = maxWidth;
		(*bitmap).blueHeight = maxHeight;
	}
    LOGI("decodeResizeImage. BLUE COMPLETE");
    

	// Set the final bitmap dimensions
	if ((*bitmap).redWidth == (*bitmap).greenWidth && (*bitmap).redWidth == (*bitmap).blueWidth
			&& (*bitmap).redHeight == (*bitmap).greenHeight && (*bitmap).redHeight == (*bitmap).blueHeight) {
		(*bitmap).width = (*bitmap).redWidth;
		(*bitmap).height = (*bitmap).redHeight;
	} else {
		freeUnsignedCharArray(&(*bitmap).red);
		freeUnsignedCharArray(&(*bitmap).green);
		freeUnsignedCharArray(&(*bitmap).blue);
		return INCONSISTENT_BITMAP_ERROR;
	}
    LOGI("decodeResizeImage. FINISHED");

	return MEMORY_OK;
}

int decodeImage(char const *filename, Bitmap* bitmap) {
    // Delete the current bitmap, just in case
    deleteBitmap(bitmap);
    
    int width, height, comp;
    unsigned char *data = stbi_load(filename, &width, &height, &comp, 0);
    LOGI("stbi_image Loaded Image. %dx%d, Components: %d. Size: %d", width, height, comp, sizeof(data));

    // Check for bad decode...
    if (!data || comp <= 2) {
        // Free Image
        stbi_image_free(data);
        return DECODE_ERROR;
    }
    
    int size = width * height;
    
    // Create Char Arrays to store pixel data
    unsigned char* red;
    unsigned char* green;
    unsigned char* blue;
    
    int resultCode = newUnsignedCharArray(size, &red);
	if (resultCode != MEMORY_OK) {
		return resultCode;
	}
	resultCode = newUnsignedCharArray(size, &green);
	if (resultCode != MEMORY_OK) {
		return resultCode;
	}
	resultCode = newUnsignedCharArray(size, &blue);
	if (resultCode != MEMORY_OK) {
		return resultCode;
	}
    
    // Split values into R, G, B
    int x, y;
    int index = 0;
	for (y = 0; y < height; y++)
	{
		for (x = 0; x < width; x++)
		{
			red[index] = data[index*comp];
			green[index] = data[(index*comp)+1];
			blue[index] = data[(index*comp)+2];
			index++;
		}
	}
    
    // Free Image
    stbi_image_free(data);
    
    (*bitmap).red = red;
    (*bitmap).green = green;
    (*bitmap).blue = blue;
    (*bitmap).redHeight = height;
    (*bitmap).redWidth = width;
    (*bitmap).greenHeight = height;
    (*bitmap).greenWidth = width;
    (*bitmap).blueHeight = height;
    (*bitmap).blueWidth = width;

	return MEMORY_OK;
}

int resizeChannel(unsigned char** channelPixels, int srcWidth, int srcHeight, int maxWidth, int maxHeight) {
	// Resize channel
	if (srcWidth > maxWidth && srcHeight > maxHeight) {
		unsigned char* scaledPixels;
		int returnCode = newUnsignedCharArray(maxWidth * maxHeight, &scaledPixels);
		if (returnCode != MEMORY_OK) {
			freeUnsignedCharArray(&scaledPixels);
			return returnCode;
		}
		returnCode = resizeChannelBicubic(*channelPixels, srcWidth, srcHeight, scaledPixels, maxWidth, maxHeight);
		if (returnCode != MEMORY_OK) {
			freeUnsignedCharArray(&scaledPixels);
			return returnCode;
		}
		//No need for hi-res channel so free the memory
		freeUnsignedCharArray(channelPixels); //channelPixels is already a pointer to a pointer

		*channelPixels = scaledPixels;
	}

	return MEMORY_OK;
}

void getBitmapRowAsIntegers(Bitmap* bitmap, int y, int* pixels) {
	unsigned int width = (*bitmap).width;
	register unsigned int i = (width*y) + width - 1;
	register unsigned int x;
	for (x = width; x--; i--) {
		pixels[x] = rgb((int)(*bitmap).red[i], (int)(*bitmap).green[i], (int)(*bitmap).blue[i]);
	}
}

void setBitmapRowFromIntegers(Bitmap* bitmap, int y, int* pixels) {
	unsigned int width = (*bitmap).width;
	register unsigned int i = (width*y) + width - 1;
	register unsigned int x;
	for (x = width; x--; i--) {
		(*bitmap).red[i] = red(pixels[x]);
		(*bitmap).green[i] = green(pixels[x]);
		(*bitmap).blue[i] = blue(pixels[x]);
	}
}

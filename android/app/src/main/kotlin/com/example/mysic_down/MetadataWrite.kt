package com.example.mysic_down

import android.graphics.*
import android.os.Build
//import android.util.Log
import androidx.annotation.RequiresApi
import kotlinx.coroutines.*
import org.jaudiotagger.audio.AudioFileIO
import org.jaudiotagger.audio.mp3.MP3File
import org.jaudiotagger.tag.FieldKey
import org.jaudiotagger.tag.Tag
import org.jaudiotagger.tag.flac.FlacTag
import org.jaudiotagger.tag.id3.valuepair.ImageFormats
import org.jaudiotagger.tag.images.ArtworkFactory
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL

class MetadataWrite {
    @RequiresApi(Build.VERSION_CODES.N)
    fun metadataWrite(map: Map<String, String>): String {
        val filepath = map["file_path"]
        if (map["type"] == "flac") {
            val f = AudioFileIO.read(filepath?.let { File(it) })
            val tag = f.tag as FlacTag
            val lyric = map["lyric"]
            if (lyric != "") {
                tag.setField(FieldKey.LYRICS, lyric)
            }

            val artist = map["artist"]
            if (artist != "") {
                tag.setField(FieldKey.ARTIST, artist)
            }
            val title = map["title"]
            if (title != "") {
                tag.setField(FieldKey.TITLE, title)
            }
            val album = map["album"]
            if (album != "") {
                tag.setField(FieldKey.ALBUM, album)
            }
            if (artist != "") {
                val imagedata = map["pic_url"]?.let { getImage(it) }
                tag.setField(
                    tag.createArtworkField(
                        imagedata,
                        6,
                        ImageFormats.MIME_TYPE_JPEG,
                        "Image",
                        1400,
                        1400,
                        24,
                        0
                    )
                )
            }
            AudioFileIO.write(f)
            return "ok"

        } else if (map["type"] == "mp3") {
            val mp3File = AudioFileIO.read(filepath?.let { File(it) }) as MP3File
            val tag: Tag = mp3File.iD3v2Tag
            val lyric = map["lyric"]
            if (lyric != "") {
                tag.setField(FieldKey.LYRICS, lyric)
            }
            val title = map["title"]
            if (title != "") {
                tag.setField(FieldKey.TITLE, title)
            }


            val artist = map["artist"]
            if (artist != "") {
                tag.setField(FieldKey.ARTIST, artist)
            }
            val album = map["album"]
            if (album != "") {
                tag.setField(FieldKey.ALBUM, album)
            }
            val picUrl = map["pic_url"]
            if (artist != "") {
                val imagedata = picUrl?.let { getImage(it) }
                if (imagedata != null) {
                    if (imagedata.isEmpty()) {
                        println("Convert jpg error")
//                        //https://music.163.com/song?id=31830618&userid=5128948380
                        return "Convert jpg error"
                    }
                }
                val artwork = ArtworkFactory.getNew()
                artwork.mimeType = "image/jpeg"
                artwork.binaryData = imagedata
                artwork.pictureType = 6
                artwork.description = "Cover"
                tag.setField(artwork)
            }
            mp3File.save()
            return "ok"
        } else return "Invalid file type"

    }

    @OptIn(DelicateCoroutinesApi::class)
    @RequiresApi(Build.VERSION_CODES.N)
    @Throws(Exception::class)
    fun getImage(fileUrl: String): ByteArray? {
        val result: Deferred<ByteArray> = GlobalScope.async {
            fetchDataFromNetwork(fileUrl)
        }
        val data = runBlocking {
            result.await()
        }
//        Log.d("data", "one ${data[0]}")
//        Log.d("data", "two ${data[1]}")
//        Log.d("data", "three ${data[2]}")
//        Log.d("data", "four ${data[3]}")
//        Log.d("data", "size ${data.size}")
        //处理png文件

        if (data[1].toInt() == 80) {
//            Log.d("pngToJpg", "png convert")
            return pngToJpg(data)
        }
        return data

    }

    @RequiresApi(Build.VERSION_CODES.N)
    suspend fun fetchDataFromNetwork(url: String): ByteArray {
        return withContext(Dispatchers.IO) {
            try {
                val myurl = URL(url)

                // 获取图片的大小信息
                var connection = myurl.openConnection() as HttpURLConnection
                connection.requestMethod = "HEAD"
                val contentLength = connection.contentLengthLong
                connection.disconnect()

                // 创建足够大的字节数组
                val imageData = ByteArray(contentLength.toInt())

                // 下载图片数据
                connection = myurl.openConnection() as HttpURLConnection
                connection.requestMethod = "GET"
                val inputStream = connection.inputStream
                var bytesRead: Int
                var offset = 0
                while (inputStream.read(imageData, offset, imageData.size - offset)
                        .also { bytesRead = it } != -1
                ) {
                    offset += bytesRead
                }
                inputStream.close()
                connection.disconnect()
                return@withContext imageData
            } catch (e: IOException) {
                e.printStackTrace()
            }
            return@withContext byteArrayOf(0)

        }
    }


    fun pngToJpg(pngBytes: ByteArray): ByteArray? {
        return try {
            // 将PNG字节数组解码为Bitmap
            val bitmap = BitmapFactory.decodeByteArray(pngBytes, 0, pngBytes.size)
            if (bitmap != null) {
                // 创建一个空白的JPEG格式的Bitmap
                val jpegBitmap =
                    Bitmap.createBitmap(bitmap.width, bitmap.height, Bitmap.Config.RGB_565)

                // 将PNG内容绘制到JPEG Bitmap上
                val canvas = Canvas(jpegBitmap)
                canvas.drawColor(Color.WHITE) // 设置背景为白色
                val zero = 0
                canvas.drawBitmap(bitmap, zero.toFloat(), zero.toFloat(), Paint())

                // 将JPEG Bitmap压缩为字节数组
                val outputStream = ByteArrayOutputStream()
                jpegBitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream)
                outputStream.toByteArray()
            } else {
                // 解码失败
                ByteArray(0)
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
            // 处理异常
            ByteArray(0)
        }
    }

}





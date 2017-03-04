/*
 *  ffmpeg.h
 *  This file is part of AVPlayerTouch framework.
 *
 *  Global FFMPEG library header files.
 *
 *  Created by iMoreApps on 3/4/2017.
 *  Copyright (C) 2017 iMoreApps Inc. All rights reserved.
 *  Author: imoreapps <imoreapps@gmail.com>
 */

#ifndef _FFMPEG_H
#define _FFMPEG_H

#ifdef __cplusplus
extern "C" {
#endif

#include <libavformat/avio.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/avassert.h>
#include <libavutil/avutil.h>
#include <libavutil/avstring.h>
#include <libavutil/dict.h>
#include <libavutil/opt.h>
#include <libavutil/time.h>
#include <libavutil/samplefmt.h>
#include <libavutil/frame.h>
#include <libswscale/swscale.h>
#include <libswresample/swresample.h>

/*
 * FFmpeg API bridge
 */
int f_av_usleep(unsigned usec);

int64_t f_av_gettime(void);

void *f_av_mallocz(size_t size) av_malloc_attrib av_alloc_size(1);

void *f_av_calloc(size_t nmemb, size_t size) av_malloc_attrib;

void f_av_free(void *ptr);

void f_av_freep(void *ptr);

uint32_t f_av_q2intfloat(AVRational q);

size_t f_av_strlcat(char *dst, const char *src, size_t size);

void f_av_log_set_level(int level);

void f_av_log_set_flags(int arg);

int f_av_log_get_flags(void);

void f_av_log(void *avcl, int level, const char *fmt, ...);

void f_av_register_all(void);

int f_avformat_network_init(void);

void f_av_init_packet(AVPacket *pkt);

void f_av_packet_unref(AVPacket *pkt);

AVFrame *f_av_frame_alloc(void);

void f_av_frame_free(AVFrame **frame);

void f_av_frame_unref(AVFrame *frame);

AVOutputFormat *f_av_oformat_next(const AVOutputFormat *f);

AVInputFormat *f_av_iformat_next(const AVInputFormat *f);

AVCodec *f_av_codec_next(const AVCodec *c);

int f_av_codec_is_encoder(const AVCodec *codec);

int f_av_codec_is_decoder(const AVCodec *codec);

void f_av_codec_set_lowres(AVCodecContext *avctx, int val);

void f_av_codec_set_pkt_timebase(AVCodecContext *avctx, AVRational val);

int f_avcodec_open2(AVCodecContext *avctx, const AVCodec *codec, AVDictionary **options);

void f_avcodec_free_context(AVCodecContext **avctx);

int f_avcodec_close(AVCodecContext *avctx);

AVCodecContext *f_avcodec_alloc_context3(const AVCodec *codec);

int f_avcodec_parameters_to_context(AVCodecContext *codec, const AVCodecParameters *par);

AVCodec *f_avcodec_find_decoder(enum AVCodecID id);

const AVCodecDescriptor *f_avcodec_descriptor_get(enum AVCodecID id);

const AVCodecDescriptor *f_avcodec_descriptor_next(const AVCodecDescriptor *prev);

int f_avcodec_fill_audio_frame(AVFrame *frame, int nb_channels,
		enum AVSampleFormat sample_fmt, const uint8_t *buf,
		int buf_size, int align);

void f_avcodec_flush_buffers(AVCodecContext *avctx);

int f_avcodec_decode_audio4(AVCodecContext *avctx, AVFrame *frame,
		int *got_frame_ptr, const AVPacket *avpkt);

int f_avcodec_decode_video2(AVCodecContext *avctx, AVFrame *picture,
		int *got_picture_ptr,
		const AVPacket *avpkt);

int f_avcodec_decode_subtitle2(AVCodecContext *avctx, AVSubtitle *sub,
		int *got_sub_ptr,
		AVPacket *avpkt);

AVDictionaryEntry *f_av_dict_get(const AVDictionary *m, const char *key, const AVDictionaryEntry *prev, int flags);

int f_av_dict_set(AVDictionary **pm, const char *key, const char *value, int flags);

const AVOption *f_av_opt_find(void *obj, const char *name, const char *unit, int opt_flags, int search_flags);

void f_av_dict_free(AVDictionary **m);

int f_av_samples_get_buffer_size(int *linesize, int nb_channels, int nb_samples, enum AVSampleFormat sample_fmt, int align);

AVRational f_av_guess_sample_aspect_ratio(AVFormatContext *format, AVStream *stream, AVFrame *frame);

int f_av_reduce(int *dst_num, int *dst_den, int64_t num, int64_t den, int64_t max);

int f_av_frame_get_channels(const AVFrame *frame);

int64_t f_av_get_default_channel_layout(int nb_channels);

int f_av_get_channel_layout_nb_channels(uint64_t channel_layout);

int64_t f_av_frame_get_best_effort_timestamp(const AVFrame *frame);

int f_swr_init(struct SwrContext *s);

void f_swr_free(struct SwrContext **s);

struct SwrContext *f_swr_alloc_set_opts(struct SwrContext *s,
		int64_t out_ch_layout, enum AVSampleFormat out_sample_fmt, int out_sample_rate,
		int64_t in_ch_layout, enum AVSampleFormat in_sample_fmt, int in_sample_rate,
		int log_offset, void *log_ctx);

int f_swr_convert(struct SwrContext *s, uint8_t **out, int out_count, const uint8_t **in, int in_count);

int f_avpicture_alloc(AVPicture *picture, enum AVPixelFormat pix_fmt, int width, int height);

int f_avpicture_fill(AVPicture *picture, const uint8_t *ptr, enum AVPixelFormat pix_fmt, int width, int height);

AVIOContext *f_avio_alloc_context(unsigned char *buffer,
		int buffer_size,
		int write_flag,
		void *opaque,
		int (*read_packet)(void *opaque, uint8_t *buf, int buf_size),
		int (*write_packet)(void *opaque, uint8_t *buf, int buf_size),
		int64_t (*seek)(void *opaque, int64_t offset, int whence));

int f_av_probe_input_buffer(AVIOContext *pb, AVInputFormat **fmt,
		const char *url, void *logctx,
		unsigned int offset, unsigned int max_probe_size);

int f_avformat_open_input(AVFormatContext **ps, const char *url, AVInputFormat *fmt, AVDictionary **options);

AVInputFormat *f_av_find_input_format(const char *short_name);

int f_avformat_find_stream_info(AVFormatContext *ic, AVDictionary **options);

void f_av_dump_format(AVFormatContext *ic, int index, const char *url, int is_output);

AVFormatContext *f_avformat_alloc_context(void);

void f_avformat_close_input(AVFormatContext **s);

const AVClass *f_avformat_get_class(void);

int f_avformat_seek_file(AVFormatContext *s, int stream_index, int64_t min_ts, int64_t ts, int64_t max_ts, int flags);

int f_av_read_frame(AVFormatContext *s, AVPacket *pkt);

int f_av_read_pause(AVFormatContext *s);

int f_av_read_play(AVFormatContext *s);

int f_av_strerror(int errnum, char *errbuf, size_t errbuf_size);

static inline char *f_av_make_error_string(char *errbuf, size_t errbuf_size, int errnum) {
	f_av_strerror(errnum, errbuf, errbuf_size);
	return errbuf;
}

#define f_av_err2str(errnum) \
    f_av_make_error_string((char[AV_ERROR_MAX_STRING_SIZE]){0}, AV_ERROR_MAX_STRING_SIZE, errnum)

#ifdef __cplusplus
}
#endif


#endif // _FFMPEG_H

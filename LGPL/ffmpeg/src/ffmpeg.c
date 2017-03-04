/*
 *  ffmpeg.h
 *  This file is part of AVPlayerTouch framework.
 *
 *  Global FFMPEG library wrapper files.
 *
 *  Created by iMoreApps on 3/4/2017.
 *  Copyright (C) 2017 iMoreApps Inc. All rights reserved.
 *  Author: imoreapps <imoreapps@gmail.com>
 */

#include "ffmpeg.h"

int f_av_usleep(unsigned usec) {
	return av_usleep(usec);
}

int64_t f_av_gettime(void) {
	return av_gettime();
}

void *f_av_mallocz(size_t size) {
	return av_mallocz(size);
}

void *f_av_calloc(size_t nmemb, size_t size) {
	return av_calloc(nmemb, size);
}

void f_av_free(void *ptr) {
	av_free(ptr);
}

void f_av_freep(void *ptr) {
	return av_freep(ptr);
}

uint32_t f_av_q2intfloat(AVRational q) {
	return av_q2intfloat(q);
}

size_t f_av_strlcat(char *dst, const char *src, size_t size) {
	return av_strlcat(dst, src, size);
}

void f_av_log_set_level(int level) {
	av_log_set_level(level);
}

void f_av_log_set_flags(int arg) {
	av_log_set_flags(arg);
}

int f_av_log_get_flags(void) {
	return av_log_get_flags();
}

void f_av_log(void *avcl, int level, const char *fmt, ...) {
	va_list vl;
	va_start(vl, fmt);
	av_log(avcl, level, fmt, vl);
	va_end(vl);
}

void f_av_register_all(void) {
	av_register_all();
}

int f_avformat_network_init(void) {
	return avformat_network_init();
}

void f_av_init_packet(AVPacket *pkt) {
	av_init_packet(pkt);
}

void f_av_packet_unref(AVPacket *pkt) {
	av_packet_unref(pkt);
}

AVFrame *f_av_frame_alloc(void) {
	return av_frame_alloc();
}

void f_av_frame_free(AVFrame **frame) {
	av_frame_free(frame);
}

void f_av_frame_unref(AVFrame *frame) {
	av_frame_unref(frame);
}

AVOutputFormat *f_av_oformat_next(const AVOutputFormat *f) {
	return av_oformat_next(f);
}

AVInputFormat *f_av_iformat_next(const AVInputFormat *f) {
	return av_iformat_next(f);
}

AVCodec *f_av_codec_next(const AVCodec *c) {
	return av_codec_next(c);
}

int f_av_codec_is_encoder(const AVCodec *codec) {
	return av_codec_is_encoder(codec);
}

int f_av_codec_is_decoder(const AVCodec *codec) {
	return av_codec_is_decoder(codec);
}

void f_av_codec_set_lowres(AVCodecContext *avctx, int val) {
	av_codec_set_lowres(avctx, val);
}

void f_av_codec_set_pkt_timebase(AVCodecContext *avctx, AVRational val) {
	av_codec_set_pkt_timebase(avctx, val);
}

int f_avcodec_open2(AVCodecContext *avctx, const AVCodec *codec, AVDictionary **options) {
	return avcodec_open2(avctx, codec, options);
}

void f_avcodec_free_context(AVCodecContext **avctx) {
	avcodec_free_context(avctx);
}

AVCodecContext *f_avcodec_alloc_context3(const AVCodec *codec) {
	return avcodec_alloc_context3(codec);
}

int f_avcodec_close(AVCodecContext *avctx) {
	return avcodec_close(avctx);
}

int f_avcodec_parameters_to_context(AVCodecContext *codec, const AVCodecParameters *par) {
	return avcodec_parameters_to_context(codec, par);
}

AVCodec *f_avcodec_find_decoder(enum AVCodecID id) {
	return avcodec_find_decoder(id);
}

const AVCodecDescriptor *f_avcodec_descriptor_get(enum AVCodecID id) {
	return avcodec_descriptor_get(id);
}

const AVCodecDescriptor *f_avcodec_descriptor_next(const AVCodecDescriptor *prev) {
	return avcodec_descriptor_next(prev);
}

int f_avcodec_fill_audio_frame(AVFrame *frame, int nb_channels,
		enum AVSampleFormat sample_fmt, const uint8_t *buf,
		int buf_size, int align) {
	return avcodec_fill_audio_frame(frame, nb_channels, sample_fmt, buf, buf_size, align);
}

void f_avcodec_flush_buffers(AVCodecContext *avctx) {
	avcodec_flush_buffers(avctx);
}

int f_avcodec_decode_audio4(AVCodecContext *avctx, AVFrame *frame,
		int *got_frame_ptr, const AVPacket *avpkt) {
	return avcodec_decode_audio4(avctx, frame, got_frame_ptr, avpkt);
}

int f_avcodec_decode_video2(AVCodecContext *avctx, AVFrame *picture,
		int *got_picture_ptr,
		const AVPacket *avpkt) {
	return avcodec_decode_video2(avctx, picture, got_picture_ptr, avpkt);
}

int f_avcodec_decode_subtitle2(AVCodecContext *avctx, AVSubtitle *sub,
		int *got_sub_ptr,
		AVPacket *avpkt) {
	return avcodec_decode_subtitle2(avctx, sub, got_sub_ptr, avpkt);
}

AVDictionaryEntry *f_av_dict_get(const AVDictionary *m, const char *key, const AVDictionaryEntry *prev, int flags) {
	return av_dict_get(m, key, prev, flags);
}

int f_av_dict_set(AVDictionary **pm, const char *key, const char *value, int flags) {
	return av_dict_set(pm, key, value, flags);
}

const AVOption *f_av_opt_find(void *obj, const char *name, const char *unit, int opt_flags, int search_flags) {
	return av_opt_find(obj, name, unit, opt_flags, search_flags);
}

void f_av_dict_free(AVDictionary **m) {
	av_dict_free(m);
}

AVRational f_av_guess_sample_aspect_ratio(AVFormatContext *format, AVStream *stream, AVFrame *frame) {
	return av_guess_sample_aspect_ratio(format, stream, frame);
}

int f_av_reduce(int *dst_num, int *dst_den, int64_t num, int64_t den, int64_t max) {
	return av_reduce(dst_num, dst_den, num, den, max);
}

int f_av_samples_get_buffer_size(int *linesize, int nb_channels, int nb_samples, enum AVSampleFormat sample_fmt, int align) {
	return av_samples_get_buffer_size(linesize, nb_channels, nb_samples, sample_fmt, align);
}

int f_av_frame_get_channels(const AVFrame *frame) {
	return av_frame_get_channels(frame);
}

int64_t f_av_get_default_channel_layout(int nb_channels) {
	return av_get_default_channel_layout(nb_channels);
}

int f_av_get_channel_layout_nb_channels(uint64_t channel_layout) {
	return av_get_channel_layout_nb_channels(channel_layout);
}

int64_t f_av_frame_get_best_effort_timestamp(const AVFrame *frame) {
	return av_frame_get_best_effort_timestamp(frame);
}

int f_swr_init(struct SwrContext *s) {
	return swr_init(s);
}

void f_swr_free(struct SwrContext **s) {
	return swr_free(s);
}

struct SwrContext *f_swr_alloc_set_opts(struct SwrContext *s,
		int64_t out_ch_layout, enum AVSampleFormat out_sample_fmt, int out_sample_rate,
		int64_t in_ch_layout, enum AVSampleFormat in_sample_fmt, int in_sample_rate,
		int log_offset, void *log_ctx) {
	return swr_alloc_set_opts(s, out_ch_layout, out_sample_fmt, out_sample_rate, in_ch_layout, in_sample_fmt, in_sample_rate, log_offset, log_ctx);
}

int f_swr_convert(struct SwrContext *s, uint8_t **out, int out_count, const uint8_t **in, int in_count) {
	return swr_convert(s, out, out_count, in, in_count);
}

int f_avpicture_alloc(AVPicture *picture, enum AVPixelFormat pix_fmt, int width, int height) {
	return avpicture_alloc(picture, pix_fmt, width, height);
}

int f_avpicture_fill(AVPicture *picture, const uint8_t *ptr, enum AVPixelFormat pix_fmt, int width, int height) {
	return avpicture_fill(picture, ptr, pix_fmt, width, height);
}

AVIOContext *f_avio_alloc_context(unsigned char *buffer,
		int buffer_size,
		int write_flag,
		void *opaque,
		int (*read_packet)(void *opaque, uint8_t *buf, int buf_size),
		int (*write_packet)(void *opaque, uint8_t *buf, int buf_size),
		int64_t (*seek)(void *opaque, int64_t offset, int whence)) {
	return avio_alloc_context(buffer, buffer_size, write_flag, opaque, read_packet, write_packet, seek);
}

int f_av_probe_input_buffer(AVIOContext *pb, AVInputFormat **fmt,
		const char *url, void *logctx,
		unsigned int offset, unsigned int max_probe_size) {
	return av_probe_input_buffer(pb, fmt, url, logctx, offset, max_probe_size);
}

int f_avformat_open_input(AVFormatContext **ps, const char *url, AVInputFormat *fmt, AVDictionary **options) {
	return avformat_open_input(ps, url, fmt, options);
}

AVInputFormat *f_av_find_input_format(const char *short_name) {
	return av_find_input_format(short_name);
}

int f_avformat_find_stream_info(AVFormatContext *ic, AVDictionary **options) {
	return avformat_find_stream_info(ic, options);
}

int f_av_read_frame(AVFormatContext *s, AVPacket *pkt) {
	return av_read_frame(s, pkt);
}

int f_av_read_pause(AVFormatContext *s) {
	return av_read_pause(s);
}

int f_av_read_play(AVFormatContext *s) {
	return av_read_play(s);
}

void f_av_dump_format(AVFormatContext *ic, int index, const char *url, int is_output) {
	av_dump_format(ic, index, url, is_output);
}

AVFormatContext *f_avformat_alloc_context(void) {
	return avformat_alloc_context();
}

void f_avformat_close_input(AVFormatContext **s) {
	avformat_close_input(s);
}

const AVClass *f_avformat_get_class(void) {
	return avformat_get_class();
}

int f_avformat_seek_file(AVFormatContext *s, int stream_index, int64_t min_ts, int64_t ts, int64_t max_ts, int flags) {
	return avformat_seek_file(s, stream_index, min_ts, ts, max_ts, flags);
}

int f_av_strerror(int errnum, char *errbuf, size_t errbuf_size) {
	return av_strerror(errnum, errbuf, errbuf_size);
}

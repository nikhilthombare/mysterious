#!/usr/bin/env ruby
# encoding : utf-8

require 'rubygems'
require 'RMagick'
include Magick

# arguments processing
if ARGV.empty?
  puts 'no arguments given'
  exit 
else
  img_name = ARGV[0]
  unless File.exists?(img_name)
    puts "no file named #{img_name}"
    exit 
  end
end

device = (ARGV.count > 1 ? ARGV[1] : 'iphone')
img = ImageList.new(img_name)

# only iOS 7.0 and above
sizes = [{
      idiom: 'iphone settings',
      size: 1024,
      scale: 1},
      {
        idiom: 'iphone settings',
        size: 512,
        scale: 1},
      {
      idiom: 'iphone settings',
      size: 20,
      scale: 1},
      {
      idiom: 'iphone settings',
      size: 20,
      scale: 2},
      {
      idiom: 'iphone settings',
      size: 20,
      scale: 3},
      {
      idiom: 'iphone settings',
      size: 29,
      scale: 1},
      {
      idiom: 'iphone settings',
      size: 29,
      scale: 2},
      {
      idiom: 'iphone settings',
      size: 29,
      scale: 3},
      {
      idiom: 'iphone spotlight',
      size: 40,
      scale: 2},
      {
      idiom: 'iphone spotlight',
      size: 40,
      scale: 3},
      {
      idiom: 'iphone app',
      size: 50,
      scale: 1},
      {
      idiom: 'iphone app',
      size: 50,
      scale: 2},
      {
      idiom: 'iphone app',
      size: 57,
      scale: 1},
      {
      idiom: 'iphone app',
      size: 57,
      scale: 2},
      {
      idiom: 'iphone app',
      size: 60,
      scale: 2},
      {
      idiom: 'iphone app',
      size: 60,
      scale: 3},
      {
      idiom: 'ipad settings',
      size: 29,
      scale: 1},
      {
      idiom: 'ipad settings',
      size: 29,
      scale: 2},
      {
      idiom: 'ipad spotlight',
      size: 40,
      scale: 1},
      {
      idiom: 'ipad spotlight',
      size: 40,
      scale: 2},
      {
      idiom: 'ipad app',
      size: 76,
      scale: 1},
      {
      idiom: 'ipad app',
      size: 76,
      scale: 2},
      {
      idiom: 'ipad app',
      size: 83.5,
      scale: 2},
      {
      idiom: 'AppIcon',
      size: 120,
      scale: 1},
      {
      idiom: 'android app',
      size: 72,
      scale: 1},
      {
      idiom: 'android app',
      size: 72,
      scale: 2},
      {
      idiom: 'android app',
      size: 48,
      scale: 1},
      {
      idiom: 'android app',
      size: 96,
      scale: 1},
      {
      idiom: 'android app',
      size: 144,
      scale: 1}]

def log(size, filename)

  #if filename != 'AppIcon'
   # s = "#{size}x#{size}"
   # s.insert(0, ' '*(9 - s.length))
   # puts "#{s}: #{filename}"
  #end
end

# delete all icon files
ia_file = 'icons/iTunesArtwork'
File.delete(ia_file) if File.exists?(ia_file)
File.delete("#{ia_file}@2x") if File.exists?("#{ia_file}@2x")
`rm icons/*.png` unless Dir['icons/*.png'].empty?

# resize
sizes.each do |s|
  if s[:idiom] == 'AppIcon'
    size = s[:scale]*s[:size]
    scaled_img = img.resize_to_fit(size, size)
    filename = 'icons/AppIcon120x120.png'
    log(size, 'AppIcon')
    scaled_img.write(filename)
  end
  if device == 'universal' || s[:idiom].start_with?(device) || s[:idiom] == 'ipad app'
    size = s[:scale]*s[:size]
    scaled_img = img.resize_to_fit(size, size)
    filename = 'icons/' + (s[:scale] > 1 ? "Icon-#{s[:size]}@#{s[:scale]}x.png" : "Icon-#{s[:size]}.png")
    log(size, filename)
    scaled_img.write(filename)
  end
end

# CarPlay
scaled_img = img.resize_to_fit(120, 120)
log(120, 'icons/Icon-120.png')
scaled_img.write('icons/Icon-120.png')

# iTunesArtwork 512
scaled_img = img.resize_to_fit(512, 512)
log(512, ia_file)
scaled_img.write("#{ia_file}.png")
`mv #{ia_file}.png #{ia_file}`

# iTunesArtwork 1024
scaled_img = img.resize_to_fit(1024, 1024)
log(1024, "#{ia_file}@2x")
scaled_img.write("#{ia_file}@2x.png")
`mv #{ia_file}@2x.png #{ia_file}@2x`
# frozen_string_literal: true

require 'chunky_png'

def read_from_file
  file_path = File.expand_path('input.txt', __dir__)
  input = File.read(file_path)
end

def process_inputs(input)
  image_array = Array.new(100) { Array.new(6) { Array.new(25, 'nil') } }

  layer_level = 0
  row_level = 0
  pixel_level = 0
  i = 0
  while i < input.length
    image_array[layer_level][row_level][pixel_level] = input[i]

    if pixel_level == 24
      row_level += 1
      pixel_level = -1

      if row_level > 5
        layer_level += 1
        row_level = 0
      end
    end
    i += 1
    pixel_level += 1
  end
  image_array
end

def count_zeros_on_each_layer(image_array)
  array_of_layer_zero_count = Array.new(100, 0)
  i = 0
  image_array.each do |layers_array|
    layers_array.each do |pixels_array|
      pixels_array.each do |pixel|
        array_of_layer_zero_count[i] += 1 if (pixel == '0' || pixel == 0)
      end
    end
    i += 1
  end
  array_of_layer_zero_count
end

def find_layer_with_least_zeros(zeros_per_layer)
  minimum = zeros_per_layer.min
  zeros_per_layer.index(minimum)
end

def find_number_of_one_digits(image_array, layer_index)
  number_of_one_digits_in_layer = 0
  image_array[layer_index].each do |pixels_array|
    pixels_array.each do |pixel|
      number_of_one_digits_in_layer += 1 if (pixel == 1 || pixel == '1')
    end
  end
  number_of_one_digits_in_layer
end

def find_number_of_two_digits(image_array, layer_index)
  number_of_two_digits_in_layer = 0
  image_array[layer_index].each do |pixels_array|
    pixels_array.each do |pixel|
      number_of_two_digits_in_layer += 1 if (pixel == 2 || pixel == '2')
    end
  end
  number_of_two_digits_in_layer
end

def find_decoded_image(image_array)
  flattened_image = Array.new(6) { Array.new(25, 'nil') }
  layer_tracker = 0
  column_tracker = 0
  pixel_tracker = 0

  image_array[0].each do |pixels_array|
    pixels_array.each do |_pixel|
      while (image_array[layer_tracker][column_tracker][pixel_tracker] == 2 || image_array[layer_tracker][column_tracker][pixel_tracker] == '2')
        layer_tracker += 1
      end
      flattened_image[column_tracker][pixel_tracker] = image_array[layer_tracker][column_tracker][pixel_tracker]
      layer_tracker = 0
      pixel_tracker += 1
    end
    column_tracker += 1
    pixel_tracker = 0
  end
  flattened_image
end

def create_png_image(flattened_image)
  png = ChunkyPNG::Image.new(30, 8, ChunkyPNG::Color::TRANSPARENT)

  row_tracker = 0
  pixel_tracker = 0
  while pixel_tracker < 25 && row_tracker < 6
    if flattened_image[row_tracker][pixel_tracker] == 1 || flattened_image[row_tracker][pixel_tracker] == '1'
      png[pixel_tracker + 1, row_tracker + 1] = ChunkyPNG::Color('white @ 1.0')
    else
      png[pixel_tracker + 1, row_tracker + 1] = ChunkyPNG::Color('black @ 1.0')
    end
    if pixel_tracker == 24
      row_tracker += 1
      pixel_tracker = -1
    end
    pixel_tracker += 1
  end

  png.save('output.png', :interlace => true)
end

def main
  input = read_from_file
  image = process_inputs(input)
  zeros_per_layer_array = count_zeros_on_each_layer(image)
  layer_with_least_zeros = find_layer_with_least_zeros(zeros_per_layer_array)
  puts find_number_of_one_digits(image, layer_with_least_zeros) * find_number_of_two_digits(image, layer_with_least_zeros)

  final_image = find_decoded_image(image)
  create_png_image(final_image)
end

main

# frozen_string_literal: true

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

def main
  input = read_from_file
  image = process_inputs(input)
  zeros_per_layer_array = count_zeros_on_each_layer(image)
  layer_with_least_zeros = find_layer_with_least_zeros(zeros_per_layer_array)
  puts find_number_of_one_digits(image, layer_with_least_zeros) * find_number_of_two_digits(image, layer_with_least_zeros)
end

main

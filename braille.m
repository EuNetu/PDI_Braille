close all
clear all

pkg load image

im = imread('C:\Users\eucli\Documents\Projetos\Matlab\PDI_Braille\banco_de_imagens\braille_y.jpeg');

figure('Name','Imagem original');
imshow(im)

imGray = rgb2gray(im);
figure('Name','Imagem original em intensidades de cinza');
imshow(imGray)

figure('Name','Histograma original');
imhist(imGray)

pontoDeCorte = 100;

im2 = uint8(zeros(size(im,1), size(im,2)));

for(i=1:1:size(im2,1)) 
  for(j=1:1:size(im2,2))
    if(im(i,j) > pontoDeCorte)
      im2(i,j,:) = 255;
    endif
  endfor
endfor

figure(4);
imshow(im2);

imfinal = im;
for(i=1:size(im,1))
  for(j=1:size(im,2))
    if(im2(i,j)==255) %pixel de background (fundo)
      imfinal(i,j,:) = 255; %"apago" - pintar de branco
    endif
  endfor
endfor
figure('Name','Grãos segmentados automaticamente')
imshow(imfinal)


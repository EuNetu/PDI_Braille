close all
clear all

pkg load image

im = imread('C:\Users\eucli\Documents\Projetos\Matlab\PDI_Braille\banco_de_imagens\braille_o_rolha.jpeg');

figure('Name','Imagem original');
imshow(im);

imSemAmarelo = im;

for(i=1:1:size(im,1)) 
  for(j=1:1:size(im,2))
    if(im(i,j,1)> 100 && im(i,j,2) > 100 && im(i,j,3) < 100)
      imSemAmarelo(i,j, 1) = 255;
      imSemAmarelo(i,j, 2) = 0;
      imSemAmarelo(i,j, 3) = 0;
    endif
  endfor
endfor

figure('Name','Imagem sem amarelo');
imshow(imSemAmarelo);

imCinza = rgb2gray(imSemAmarelo);
figure('Name','Imagem original em intensidades de cinza');
imshow(imCinza);

figure('Name','Histograma');
imhist(imCinza);

pontoDeCorte = 100;

im2 = uint8(zeros(size(im,1), size(im,2)));

for(i=1:1:size(im2,1)) 
  for(j=1:1:size(im2,2))
    if(imCinza(i,j) > pontoDeCorte)
      im2(i,j,:) = 255;
    endif
  endfor
endfor

figure('Name', 'Máscara');
imshow(im2);

imfinal = im;
for(i=1:size(im,1))
  for(j=1:size(im,2))
    if(im2(i,j)==255) %pixel de background (fundo)
      imfinal(i,j,:) = 255; %"apago" - pintar de branco
    endif
  endfor
endfor
figure('Name','Imagem final');
imshow(imfinal);


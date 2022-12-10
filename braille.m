close all
clear all

pkg load image

im = imread('C:\Users\eucli\Documents\Projetos\Matlab\PDI_Braille\banco_de_imagens\braille_a_biscoito.jpeg');

figure('Name','Imagem original');
imshow(im);

imSemAmarelo = im;

figure('Name','Imagem sem amarelo');
imshow(imSemAmarelo);

imCinza = rgb2gray(imSemAmarelo);
figure('Name','Imagem original em intensidades de cinza');
imshow(imCinza);

figure('Name','Histograma');
imhist(imCinza);

pontoDeCorte = 100;

im2 = imCinza < pontoDeCorte;

%erosão
imsaida = im2;

EE = [0 0 0 1 1 1 0 0 0; 
      0 0 1 1 1 1 1 0 0; 
      0 1 1 1 1 1 1 1 0; 
      1 1 1 1 1 1 1 1 1; 
      1 1 1 1 1 1 1 1 1; 
      1 1 1 1 1 1 1 1 1; 
      0 1 1 1 1 1 1 1 0; 
      0 0 1 1 1 1 1 0 0; 
      0 0 0 1 1 1 0 0 0];

fator = floor(size(EE, 1)/2);

for(i=fator:size(im2,1)-fator)
  for(j=fator:size(im2,2)-fator)
    if(im2(i,j)==1)
      %verificando se o EE está contido na frente (objeto)
      viz = im2(i-fator:i+fator,j-fator:j+fator);
      
      flag = false;
      for(x=1: size(EE, 1))
        for(y=1: size(EE, 2))
          if(EE(x, y) == 1)
            if(viz(x,y) != EE(x,y))
              flag = true;
              break;
            end
          end
        end
        if(flag)
          break;
        end
      end
      if(flag)
        imsaida(i,j) = false;
      end
    end
  end
end
imsaida2 = imsaida;

for(i=fator:size(imsaida,1)-fator)
  for(j=fator:size(imsaida,2)-fator)
    if(imsaida(i,j)==1)
      %verificando se o EE está contido na frente (objeto)
      viz2 = imsaida(i-fator:i+fator,j-fator:j+fator);
      
      flag2 = false;
      for(x=1: size(EE, 1))
        for(y=1: size(EE, 2))
          if(EE(x, y) == 1)
            if(viz2(x,y) != EE(x,y))
              flag2 = true;
              break;
            end
          end
        end
        if(flag2)
          break;
        end
      end
      if(flag2)
        imsaida2(i,j) = false;
      end
    end
  end
end



figure('Name','Imagem erodida');
imshow(imsaida);

im2 = imsaida2;

imfinal = im;
for(i=1:size(im,1))
  for(j=1:size(im,2))
    if(im2(i,j)==255) %pixel de background (fundo)
      imfinal(i,j,:) = 255; %"apago" - pintar de branco
    endif
  endfor
endfor

imRotulada = uint8(zeros(size(imsaida2,1), size(imsaida2,2)));
novoRotulo = 40;
linha = 1;
for(i=1:size(imRotulada,1))
  for(j=1:size(imRotulada,2))
    if(imsaida2(i,j)==1) %pixel é foreground, deve ser analisado
      if((imsaida2(i-1,j)==0) && (imsaida2(i,j-1)==0))
        imRotulada(i,j) = novoRotulo;
        novoRotulo++;
      else
        if((imsaida2(i-1,j)==1)&&(imsaida2(i,j-1)==0)) %rouba o rotulo do de cima
          imRotulada(i,j) = imRotulada(i-1,j);
        else
          if((imsaida2(i-1,j)==0)&&(imsaida2(i,j-1)==1)) % rouba o rotulo do da esq
            imRotulada(i,j) = imRotulada(i,j-1);
          else
            if((imsaida2(i-1,j)==1)&&(imsaida2(i,j-1)==1)&&(imRotulada(i-1,j)==imRotulada(i,j-1))) %roubo um dos dois rotulos
              imRotulada(i,j) = imRotulada(i-1,j);
            else
              if((imsaida2(i-1,j)==1)&&(imsaida2(i,j-1)==1)&&(imRotulada(i-1,j)!=imRotulada(i,j-1))) %roubo um dos dois rotulos e anotar o erro de rotulação
                imRotulada(i,j) = imRotulada(i-1,j);
                if(imRotulada(i-1,j)<imRotulada(i,j-1))
                  erros(linha,1) = imRotulada(i-1,j);
                  erros(linha,2) = imRotulada(i,j-1);
                else
                  erros(linha,1) = imRotulada(i,j-1);
                  erros(linha,2) = imRotulada(i-1,j);
                endif
                linha++;
              endif
            endif
          endif
        endif
      endif
    endif
  endfor
endfor

figure('Name','Imagem rotulada com erros')
imshow(imRotulada, [min(min(imRotulada)) max(max(imRotulada))])

%ordenação d amatriz de erros
erros = sort(erros,1);
%retidada de linhas iguais
erros = unique(erros,'rows');

for(k=1:size(erros,1))
  for(i=1:size(imRotulada,1))
    for(j=1:size(imRotulada,2))
      if(imRotulada(i,j)==erros(k,1))
        imRotulada(i,j) = erros(k,2);
      endif
    endfor
  endfor
endfor
qtdObjetos = size(unique(imRotulada),1)-1;

figure('Name','Imagem rotulada SEM erros')
imshow(imRotulada, [min(min(imRotulada)) max(max(imRotulada))])
title(qtdObjetos)

if(qtdObjetos == 1)
  figure('Name','Resultado Final')
  imshow(imfinal)
  title("A")
end
if(qtdObjetos == 2)
  figure('Name','Resultado Final')
  imshow(imfinal)
  title("A")
end
if(qtdObjetos == 3)
  figure('Name','Resultado Final')
  imshow(imfinal)
  title("A")
end
if(qtdObjetos == 4)
  figure('Name','Resultado Final')
  imshow(imfinal)
  title("A")
end
if(qtdObjetos == 5)
  figure('Name','Resultado Final')
  imshow(imfinal)
  title("A")
end
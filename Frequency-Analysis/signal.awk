BEGIN { pi = 3.14159; N = 2048; f1 = 60.; f2 = 128; 
 
        for(i=0; i < N; ++i){
         t = i * 2*pi/N
         speed = 60. * freq;  
         printf("%12.4f,%12.4f,%12.4f,\n",t,speed,sin(2*pi*f1*t)*sin(2*pi*f2*t))
        }
      }

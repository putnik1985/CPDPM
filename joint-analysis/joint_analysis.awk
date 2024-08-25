BEGIN{FS=","; bolt = 0; pi = 3.14159; }

$1 ~ /_bolt$/ { bolt++; x[bolt] = $2; y[bolt] = $3; d[bolt] = $4;}
$1 ~ /_mz/ { mz = $2;}
$1 ~ /_qx/ { qx = $2;}
$1 ~ /_qy/ { qy = $2;}
$1 ~ /_boltsy/ {bolt_sy = $2;}
$1 ~ /_boltsu/ {bolt_su = $2;}
$1 ~ /_sfc/ {sfc = $2;}
$1 ~ /_plate_thickness/ {t = $2;}
$1 ~ /_platesy/ {platesy = $2;}
$1 ~ /_platesu/ {platesu = $2;}


END{ 
   sx = 0.0;
   sy = 0.0;
    s = 0.0;
   for(i=1; i<=bolt; ++i){
    sx+=x[i] * pi * d[i] * d[i] / 4.;
    sy+=y[i] * pi * d[i] * d[i] / 4.;
     s+=pi * d[i] * d[i] / 4.;
   }
   print;
   printf("Moment:%12.2f\n", mz);
   printf("    Qx:%12.2f\n", qx);
   printf("    Qy:%12.2f\n", qy);
   print;
   xc = sx / s; yc = sy / s;
   printf("    xc:%12.2f\n",xc);
   printf("    yc:%12.2f\n",yc);
   print;

   rsquared = 0;
   for(i=1; i<=bolt; ++i){
    r[i] = sqrt((x[i] - xc) * (x[i] - xc) + (y[i] - yc) * (y[i] - yc));
    ####print(r[i] * r[i]);
    rsquared+=r[i] * r[i];
   }

   for(i=1;i<=bolt;++i)
    F[i] = mz * r[i] / rsquared;

   Fx = qx / bolt;
   Fy = qy / bolt;
   ###print "number of bolts:", bolt;
   printf("Bolts Margins Of Safety Table\n");
   printf("%12s%12s%12s%12s%12s\n","tau,ksi","x,in","y,in","MSy","MSu");

   for(i=1; i<=bolt; ++i){
    force_x = Fx - F[i] * (x[i] - xc) / r[i];
    #####print(-F[i] * (x[i] - xc)/r[i]);
    force_y = Fy + F[i] * (y[i] - yc) / r[i];
    force = sqrt(force_x * force_x + force_y * force_y);
    ####print(force);
    tau[i] = force / (pi * d[i] * d[i] / 4.) / 1000.; ### calculate in ksi
    msy = bolt_sy / (sfc * tau[i]) - 1.0;
    msu = bolt_su / (sfc * tau[i]) - 1.0;
    printf("%12.2f%12.4f%12.4f%12.2f%12.2f\n",tau[i],x[i],y[i],msy,msu);
  }
   print;
   printf("Bearing Margins Of Safety Table\n");
   printf("%12s%12s%12s%12s%12s\n","tau,ksi","x,in","y,in","MSy","MSu");
     
   for(i=1; i<=bolt; ++i){
    force_x = Fx - F[i] * (x[i] - xc) / r[i];
    force_y = Fy + F[i] * (y[i] - yc) / r[i];
    force = sqrt(force_x * force_x + force_y * force_y);
    tau[i] = force / (d[i] * t) / 1000.; ### calculate in ksi
    msy = bolt_sy / (sfc * tau[i]) - 1.0;
    msu = bolt_su / (sfc * tau[i]) - 1.0;
    printf("%12.2f%12.4f%12.4f%12.2f%12.2f\n",tau[i],x[i],y[i],msy,msu);
  }
  print;
}

import numpy
import matplotlib
import sys 
import math
import cmath
import scipy

POINTS = 100 
DF = 0.5

class Truck:
   def __init__(self, data):

     m = data["mass"]
     jd = data["jd"]
     c1 = data["c1"]
     c2 = data["c2"]
     b = data["b"]
     l = data["l"]

     self.bs1 = data["bs"]
     self.as1 = data["as"]

     a1 = data["a1"]
     a2 = data["a2"]
     v = data["v"]

     self.M = numpy.array([ [m ,0.0], [0.0, jd] ])
     self.K = numpy.array([ [ c1 + c2, c1 * b - c2 * (l-b)], [c1 * b - c2 * (l-b), c1 * pow(b,2) + c2 * pow(l-b,2)]]) 
     self.C = numpy.array([ [ a1 + a2, a1 * b - a2 * (l-b)], [a1 * b - a2 * (l-b), a1 * pow(b,2) + a2 * pow(l-b,2)]])
     self.K1 = numpy.array([ [c1, c2], [c1 * b, -c2 * (l - b)] ])
     self.C1 = numpy.array([ [a1, a2], [a1 * b, -a2 * (l - b)] ])
     self.T = l / v
     self.v = v

   def input_psd(self, omega):
     return self.as1 * self.v / ( 2 * math.pi * (pow(omega,2) + self.bs1 * pow(self.v,2)))
 
   def cross_psd(self, omega):
     Sh = self.input_psd(omega)
     factor = cmath.exp( 1j * omega * self.T)
     S = numpy.array([[Sh,factor * Sh],[factor.conjugate() * Sh, Sh]]) 
     return S

   def transfer_function(self, omega):
     s = 1j * omega
     a = s * s * self.M + s * self.C + self.K
     b = self.K1 + s * self.C1  
     w = numpy.dot(numpy.linalg.inv(a), b)
     return w

if __name__ == "__main__":

   print("Random Vibration Analysis:")
   data = {} ##contains input data for the analysis

   if len(sys.argv) >= 2:
    input_file = sys.argv[1]
    with open(input_file,"r") as fh:
      while True:
        line = fh.readline()
        if line:
          #####print(line)
          words = line.split(",")
          data[words[0].lower()] = float(words[1])
       
        else:
          break

    truck = Truck(data)

    print()
    print("input PSD:")
    for x in range(POINTS):
      omega = 2 * math.pi * x * DF
      y = truck.input_psd(omega)
      print("{:8.2f}{:12.6f}".format(omega,y))
      
    print()
    print("Natural frequencies, Hz:")

    a = numpy.dot( numpy.linalg.inv(truck.M), truck.K)
    eigenvalues, eigenvectors = numpy.linalg.eig(a)
    for eig in eigenvalues:
      print("{:8.2f}".format(math.sqrt(eig) / (2 * math.pi)))

    print()
    print("Mode shapes in columns (normilized to mass matrix):")
    norm = numpy.dot(eigenvectors.T,numpy.dot(truck.M, eigenvectors))
    num_vectors = eigenvectors.shape[1] 
    for i in range(num_vectors):
      eigenvectors[:,i] = eigenvectors[:,i] / math.sqrt(norm[i,i])

    #####print(eigenvectors)
    for i in range(num_vectors):
      for j in range(num_vectors):
        sys.stdout.write("{:8.3f}".format(eigenvectors[i,j]))
      sys.stdout.write("\n")

    norm = numpy.dot(eigenvectors.T,numpy.dot(truck.M, eigenvectors))

    print()
    print("PSD of the CG Displacement and Angle Displacement:")

    u = [] 
    v = [] 
    phi = [] 

    for x in range(POINTS):
      omega = 2 * math.pi * x * DF
      S = truck.cross_psd(omega)
      W = truck.transfer_function(omega)
      iter = S.shape[1]
      numbers = S.shape[0]

      response = numpy.array([0 + 0.j,0 + 0.j])
      for cur in range(numbers):
        for j in range(iter):
          for k in range(iter):
            response[cur] += W[cur,j]*W[cur,k].conjugate() * S[j,k]

      u.append(omega)
      v.append(response[0].real) 
      phi.append(response[1].real)
      print("{:4.2f}{:8.6f}{:8.6f}{:8.6f}{:8.6f}".format(omega / (2 * math.pi), response[0].real, response[1].real,response[0].imag,response[1].imag))

    print()
    print("input PSD rms:")
    dispersia = scipy.integrate.quad(lambda x: truck.input_psd(x) / (2*math.pi), -numpy.inf, numpy.inf)
    print(f"Input Dispersia: {dispersia[0]:.4f}")
    print(f"Input RMS: {math.sqrt(dispersia[0]):.4f}")
    print()
    dispersia = scipy.integrate.simpson(v,x=u) / (2 * math.pi)
    print(f"CofG Dispersia: {dispersia:.4f}")
    print(f"CofG RMS: {math.sqrt(dispersia):.4f}")
    print()
    dispersia = scipy.integrate.simpson(phi,x=u) / ( 2 * math.pi)
    print(f"Angle Dispersia: {dispersia:.4f}")
    print(f"Angle RMS: {math.sqrt(dispersia):.4f}")

   else:
    print("no input file")

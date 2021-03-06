library(lfe)
options(digits=3,warn=1,lfe.threads=2)
set.seed(42)
x <- rnorm(100)
x2 <- rnorm(length(x))
x3 <- rnorm(length(x))
id <- factor(sample(10, length(x), replace=TRUE))
id.eff <- rnorm(nlevels(id))
y <- x + x2 + x3 + id.eff[id] + rnorm(length(x))
z <- x/2 + x2/2 + x3/2 + id.eff[id]/2 + rnorm(length(x))
v <- x/3 + x2/2 + x3/2 + id.eff[id]/2 + rnorm(length(x))
w <- x/2 + x2/3 + x3/2 + id.eff[id]/3 + rnorm(length(x))
#write.dta(data.frame(v,w,y,z,x,x2,x3,id),'mlhs.dta')
est <- felm(v|w|y|z ~ x+x2+x3|id)
for(lh in est$lhs) {
    print(summary(est, lhs=lh, robust=TRUE))
}
summary(est, lhs='z', robust=TRUE)
summary(zest <- felm(z ~x+x2+x3|id), robust=TRUE)
getfe(zest,se=TRUE)
getfe(est,method='cg',se=TRUE,lhs=c('w','z'))
lhs <- cbind(v,w,y,z)
rhs <- cbind(x,x2,x3)
est <- felm(lhs ~rhs|id)
summary(est,lhs='lhs.z', robust=TRUE)
getfe(est,se=TRUE)

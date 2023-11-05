for i in open('testData.bin', 'rb').read():
    print('{0:#x}'.format(i), end=' ')

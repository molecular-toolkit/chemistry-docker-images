

def run_singlepoint(parameters):
    """ Drive the calculation, based on passed parameters

    Args:
        parameters (dict): dictionary describing this run (see
           https://github.com/Autodesk/molecular-design-toolkit/wiki/Generic-parameter-names )
    """

    mol =




class PySCFCalculator(object):






class LazyClassMap(object):
    """ For lazily importing classes from modules (when there's a lot of import overhead)

    Class names should be stored as their *absolute import strings* so that they can be imported
    only when needed

    Example:
        >>> myclasses = LazyClassMap({'od': 'collections.OrderedDict'})
        >>> myclasss['od']()
        OrderedDict()
    """
    def __init__(self, mapping):
        self.mapping = mapping

    def __getitem__(self, key):
        import importlib
        fields = self.mapping[key].split('.')
        cls = fields[-1]
        modname = '.'.join(fields[:-1])
        mod = importlib.import_module(modname)
        return getattr(mod, cls)

    def __contains__(self, item):
        return item in self.mapping

    def __iter__(self):
        return iter(self.mapping)



THEORIES = LazyClassMap({'hf': 'pyscf.scf.RHF', 'rhf': 'pyscf.scf.RHF',
                         'uhf': 'pyscf.scf.UHF',
                         'mcscf': 'pyscf.mcscf.CASSCF', 'casscf': 'pyscf.mcscf.CASSCF',
                         'casci': 'pyscf.mcscf.CASCI',
                         'mp2': 'pyscf.mp.MP2',
                         'dft': 'pyscf.dft.RKS', 'rks': 'pyscf.dft.RKS', 'ks': 'pyscf.dft.RKS'})
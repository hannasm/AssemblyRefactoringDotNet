using Mono.Cecil;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssemblyRefactoring
{
    public class AssemblyRefactoringContext
    {
        public readonly string _targetFileName;
        public readonly AssemblyDefinition _assembly;

        public AssemblyRefactoringContext(string targetAssembly)
        {
            _targetFileName = targetAssembly;

            var readerParameters = new ReaderParameters { ReadSymbols = true };
            _assembly = AssemblyDefinition.ReadAssembly(_targetFileName, readerParameters);
        }

        public void Save(string outFile)
        {
            var writerParameters = new WriterParameters { WriteSymbols = true };
            _assembly.Write(outFile, writerParameters);
        }

        public void RenameAssemblyName(string oldName, string newName)
        {
            if (_assembly.Name.Name.StartsWith(oldName))
            {
                _assembly.Name.Name = newName + _assembly.Name.Name.Substring(oldName.Length);
            }
        }
        public void RenameNamespace(string oldName, string newName)
        {
            foreach (var module in _assembly.Modules)
            {
                HashSet<TypeReference> alreadyRenamed = new HashSet<TypeReference>();

                foreach (var type in module.Types)
                {
                    if (alreadyRenamed.Contains(type)) { continue; }
                    else { alreadyRenamed.Add(type); }
                    if (type.Namespace.StartsWith(oldName))
                    {
                        type.Namespace = newName + type.Namespace.Substring(oldName.Length);
                    }
                }
                foreach (var typeRef in module.GetTypeReferences())
                {
                    if (alreadyRenamed.Contains(typeRef)) { continue; }
                    else { alreadyRenamed.Add(typeRef); }

                    if (typeRef.Namespace.StartsWith(oldName))
                    {
                        typeRef.Namespace = newName + typeRef.Namespace.Substring(oldName.Length);
                    }
                }
            }
        }
        public void RenameAssemblyReference(string oldName, string newName)
        {
            foreach (var module in _assembly.Modules)
            {
                foreach (var ar in module.AssemblyReferences)
                {
                    if (ar.Name.StartsWith(oldName))
                    {
                        ar.Name = newName + ar.Name.Substring(oldName.Length);
                    }
                }
            }
        }
    }
}

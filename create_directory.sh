sudo chmod 777 create_directory.sh
while getopts n:p:r: flag
do
        case "${flag}" in
                n) name=${OPTARG};;
                p) page=${OPTARG};;
                r) router=${OPTARG};;
        esac
done
mkdir -p $name/{ui/{components,page,layout},models,modules,apis,router} && cd $name && touch ui/layout/Index.vue && touch ui/page/$page.vue && touch models/"${page}"Models.ts && touch modules/"${page}"Modules.ts && touch apis/"${page}"Apis.ts

if [[ $router != "" ]]
then
    touch router/"${router}"Routes.ts 
    printf "
    import ${page} from '@/${name}/ui/page/${page}.vue'
    // import { PAGE_MENU_ID as PagePermissionCode } from '@/manage-user/PagePermissionConfig'
    const ${router}Routes = (props: string) => [
    {
        path: '${name}',
        name: props + '.${name}',
        meta: {
        layout: '${name}',
        auth: true,
        permissionId: 100000,
        icon: '',
        storeName: '${page}',
        breadcrumb: [
            {
            text: '',
            active: false,
            action: 'add'
            },
        ],
        },
        component: ${page},
    },
    ]

    export default ${router}Routes
" read -r page,name,router >> router/"${router}"Routes.ts
else
touch router/"${name}"Routes.ts
printf "
import ${page} from '@/${name}/ui/page/${page}.vue'
// import { PAGE_MENU_ID as PagePermissionCode } from '@/manage-user/PagePermissionConfig'
const ${name}Routes = (props: string) => [
  {
    path: '${name}',
    name: props + '.${name}',
    meta: {
      layout: '${name}',
      auth: true,
      permissionId: 100000,
      icon: '',
      storeName: '${page}',
      breadcrumb: [
        {
          text: '',
          active: false,
          action: 'add'
        },
      ],
    },
    component: ${page},
  },
]

export default ${name}Routes

" read -r page,name >> router/"${name}"Routes.ts
fi

printf "
import { IResponse } from '@/app/models/response'
import { post } from '@/app/networks/httpSession'

enum URL {
  LIST = '',
}
export class ${page}Api {}
" read -r page >> apis/"${page}"Apis.ts

printf "
export interface I${page}Model {}
" read -r page >> models/"${page}"Models.ts

printf "
import { Module, VuexModule, Mutation, Action } from 'vuex-module-decorators'

@Module({
  name: '${page}',
  namespaced: true,
  stateFactory: true,
})
export default class extends VuexModule {}
" read -r page >> modules/"${page}"Modules.ts

printf "
<template>
  <div class="${name}-container"></div>
</template>

<script lang="ts">
import Vue from 'vue'
export default Vue.extend({
  name: ${page}
})
</script>

<style lang="scss" scoped>

</style>" read -r page,name >> ui/page/$page.vue

printf "<template>
  <BaseContent class="dashboard-container">
    <Modal />
    <router-view />
  </BaseContent>
</template>

<script lang="ts">
import Vue from 'vue'
import BaseContent from '@/app/ui/components/BaseContent.vue'
import Modal from '@/app/ui/components/Modal.vue'
export default Vue.extend({
  name: ${page}Layout,
  components: {
    Modal,
    BaseContent,
  },
})
</script>

<style scoped>
</style>
" read -r page >> ui/layout/Index.vue


# mkdir $1/ui
# mkdir $1/models
# mkdir $1/modules